#include "DirectC.h"
#include <curses.h>
#include <stdio.h>
#include <signal.h>
#include <ctype.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/signal.h>
#include <time.h>
#include <string.h>

#define PARENT_READ     readpipe[0]
#define CHILD_WRITE     readpipe[1]
#define CHILD_READ      writepipe[0]
#define PARENT_WRITE    writepipe[1]
#define NUM_HISTORY     16500
#define NUM_ARF         64
#define NUM_STAGES      5
#define NOOP_INST       0x47ff041f
#define NUM_REG_GROUPS  8

// random variables/stuff
int fd[2], writepipe[2], readpipe[2];
int stdout_save;
int stdout_open;
void signal_handler_IO (int status);
int wait_flag=0;
char done_state;
char echo_data;
FILE *fp;
FILE *fp2;
int setup_registers = 0;
int stop_time;
int done_time = -1;
char time_wrapped = 0;

// Structs to hold information about each register/signal group
typedef struct win_info {
  int height;
  int width;
  int starty;
  int startx;
  int color;
} win_info_t;

typedef struct reg_group {
  WINDOW *reg_win;
  char ***reg_contents;
  char **reg_names;
  int num_regs;
  win_info_t reg_win_info;
} reg_group_t;

// Window pointers for ncurses windows
WINDOW *title_win;
WINDOW *comment_win;
WINDOW *time_win;
WINDOW *sim_time_win;
WINDOW *instr_win;
WINDOW *clock_win;
WINDOW *if_id_win;
WINDOW *pr_win;
WINDOW *rs_win;
WINDOW *ex_pipe_win;
WINDOW *rc_win;
WINDOW *lq_sq_win;
WINDOW *mem_win;
WINDOW *id_cache_win;
WINDOW *cache_control_win;
WINDOW *arf_win;
WINDOW *misc_win;

// arrays for register contents and names
int history_num=0;
int num_misc_regs;
int num_if_id_regs = 0;
int num_pr_regs = 0;
int num_rs_regs = 0;
int num_ex_pipe_regs = 0;
int num_rc_regs = 0;
int num_lq_sq_regs = 0;
int num_mem_regs = 0;
int num_id_cache_regs = 0;
int num_cache_control_regs = 0;
char readbuffer[2048];
char **timebuffer;
char **cycles;
char *clocks;
char *resets;
char **inst_contents;
char ***if_id_contents;
char ***pr_contents;
char ***rs_contents;
char ***ex_pipe_contents;
char ***rc_contents;
char ***lq_sq_contents;
char ***mem_contents;
char ***id_cache_contents;
char ***cache_control_contents;
char **arf_contents;
char ***misc_contents;
char **if_id_reg_names;
char **pr_reg_names;
char **rs_reg_names;
char **ex_pipe_reg_names;
char **rc_reg_names;
char **lq_sq_reg_names;
char **mem_reg_names;
char **id_cache_reg_names;
char **cache_control_reg_names;
char **misc_reg_names;

char *get_opcode_str(int inst, int valid_inst);
void parse_register(char* readbuf, int reg_num, char*** contents, char** reg_names);
int get_time();


// Helper function for ncurses gui setup
WINDOW *create_newwin(int height, int width, int starty, int startx, int color){
  WINDOW *local_win;
  local_win = newwin(height, width, starty, startx);
  wbkgd(local_win,COLOR_PAIR(color));
  wattron(local_win,COLOR_PAIR(color));
  box(local_win,0,0);
  wrefresh(local_win);
  return local_win;
}

// Function to draw positive edge or negative edge in clock window
void update_clock(char clock_val){
  static char cur_clock_val = 0;
  // Adding extra check on cycles because:
  //  - if the user, right at the beginning of the simulation, jumps to a new
  //    time right after a negative clock edge, the clock won't be drawn
  if((clock_val != cur_clock_val) || strncmp(cycles[history_num],"      0",7) == 1){
    mvwaddch(clock_win,3,7,ACS_VLINE | A_BOLD);
    if(clock_val == 1){

      //we have a posedge
      mvwaddch(clock_win,2,1,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,ACS_ULCORNER | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      mvwaddch(clock_win,4,1,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_LRCORNER | A_BOLD);
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
    } else {

      //we have a negedge
      mvwaddch(clock_win,4,1,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,ACS_LLCORNER | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      mvwaddch(clock_win,2,1,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_URCORNER | A_BOLD);
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
    }
  }
  cur_clock_val = clock_val;
  wrefresh(clock_win);
}

// Function to create and initialize the gui
// Color pairs are (foreground color, background color)
// If you don't like the dark backgrounds, a safe bet is to have
//   COLOR_BLUE/BLACK foreground and COLOR_WHITE background
void setup_gui(FILE *fp){
  initscr();
  if(has_colors()){
    start_color();
    init_pair(1,COLOR_CYAN,COLOR_BLACK);    // shell background
    init_pair(2,COLOR_YELLOW,COLOR_RED);
    init_pair(3,COLOR_RED,COLOR_BLACK);
    init_pair(4,COLOR_YELLOW,COLOR_BLUE);   // title window
    init_pair(5,COLOR_YELLOW,COLOR_BLACK);  // register/signal windows
    init_pair(6,COLOR_RED,COLOR_BLACK);
    init_pair(7,COLOR_MAGENTA,COLOR_BLACK); // pipeline window
  }
  curs_set(0);
  noecho();
  cbreak();
  keypad(stdscr,TRUE);
  wbkgd(stdscr,COLOR_PAIR(1));
  wrefresh(stdscr);
  int pipe_width=0;

  //instantiate the title window at top of screen
  title_win = create_newwin(3,COLS,0,0,4);
  mvwprintw(title_win,1,1,"WELCOME TO DEBUG HELL, MOTHERFUCKER");
  mvwprintw(title_win,1,COLS-45,"COURTESY OF: BEN KEMPKE/JOSH SMITH");
  wrefresh(title_win);

  //instantiate time window at right hand side of screen
  time_win = create_newwin(3,10,3,COLS-10,5);
  mvwprintw(time_win,0,3,"TIME");
  wrefresh(time_win);

  //instantiate a sim time window which states the actual simlator time
  sim_time_win = create_newwin(3,10,6,COLS-10,5);
  mvwprintw(sim_time_win,0,1,"SIM TIME");
  wrefresh(sim_time_win);

  //instantiate a window to show which clock edge this is
  clock_win = create_newwin(6,15,3,COLS-25,5);
  mvwprintw(clock_win,0,5,"CLOCK");
  mvwprintw(clock_win,1,1,"cycle:");
  update_clock(0);
  wrefresh(clock_win);

  // instantiate a window for the ARF on the right side
  arf_win = create_newwin(66,28,9,COLS-28,5);
  mvwprintw(arf_win,0,4,"Physical Register");
  int i=0;
  char tmp_buf[32];
  for (; i < NUM_ARF; i++) {
    sprintf(tmp_buf, "r%02d: ", i);
    mvwprintw(arf_win,i+1,1,tmp_buf);
  }
  wrefresh(arf_win);

  //instantiate window to visualize instructions in pipeline below title

  //instantiate window to visualize IF stage (including IF/ID)
  if_id_win = create_newwin((num_if_id_regs+2),35,3,0,5);
  mvwprintw(if_id_win,0,10,"IF/ID");
  wrefresh(if_id_win);

  //instantiate window to visualize IF/ID signals
  pr_win = create_newwin((num_pr_regs+2),35,3+(num_rs_regs+2),35,5);
  mvwprintw(pr_win,0,10,"PR outputs");
  wrefresh(pr_win);

  //instantiate a window to visualize rs
  rs_win = create_newwin((num_rs_regs+2),35,3,35,5);
  mvwprintw(rs_win,0,13,"RS");
  wrefresh(rs_win);

  //instantiate a window to visualize ex pipeline signals
  ex_pipe_win = create_newwin((num_ex_pipe_regs+2),40,3,70,1);
  mvwprintw(ex_pipe_win,0,4,"Ex Pipeline Outputs");
  wrefresh(ex_pipe_win);

  //instantiate a window to visualize ROB connect
  rc_win = create_newwin((num_rc_regs+2),35,3,110,5);
  mvwprintw(rc_win,0,10,"Rob Connect");
  wrefresh(rc_win);

  //instantiate a window to visualize EX/MEM
  lq_sq_win = create_newwin((num_lq_sq_regs+2),40,3,145,5);
  mvwprintw(lq_sq_win,0,12,"LQ/SQ");
  wrefresh(lq_sq_win);

  //instantiate a window to visualize WB stage
  cache_control_win = create_newwin((num_cache_control_regs+2),45,3,185,5);
  mvwprintw(cache_control_win,0,10,"$ controller");
  wrefresh(cache_control_win);

  //instantiate a window to visualize MEM stage
  mem_win = create_newwin((num_mem_regs+2),30,(num_id_cache_regs+2)+3,230,5);
  mvwprintw(mem_win,0,10,"MEM STAGE");
  wrefresh(mem_win);

  //instantiate a window to visualize id cache
  id_cache_win = create_newwin((num_id_cache_regs+2),30,3,230,5);
  mvwprintw(id_cache_win,0,12,"I/D Cache");
  wrefresh(id_cache_win);

  // instantiate window to visualize ex-lsq regs/wires
  misc_win = create_newwin((num_misc_regs+2),38,(num_ex_pipe_regs+2)-(num_misc_regs+2)+3,110,1);
  mvwprintw(misc_win,0,12,"Ex-LSQ outputs");
  wrefresh(misc_win);


  //instantiate an instructional window to help out the user some
  instr_win = create_newwin(7,30,LINES-7,0,5);
  mvwprintw(instr_win,0,9,"INSTRUCTIONS");
  wattron(instr_win,COLOR_PAIR(5));
  mvwaddstr(instr_win,1,1,"'n'   -> Next clock edge");
  mvwaddstr(instr_win,2,1,"'b'   -> Previous clock edge");
  mvwaddstr(instr_win,3,1,"'c/g' -> Goto specified time");
  mvwaddstr(instr_win,4,1,"'r'   -> Run to end of sim");
  mvwaddstr(instr_win,5,1,"'q'   -> Quit Simulator");
  wrefresh(instr_win);
  


  refresh();
}

// This function updates all of the signals being displayed with the values
// from time history_num_in (this is the index into all of the data arrays).
// If the value changed from what was previously display, the signal has its
// display color inverted to make it pop out.
void parsedata(int history_num_in){
  static int old_history_num_in=0;
  static int old_head_position=0;
  static int old_tail_position=0;
  int i=0;
  int data_counter=0;
  char *opcode;
  int tmp=0;
  int tmp_val=0;
  char tmp_buf[32];
  int pipe_width = COLS/6;

  // Handle updating resets
  if (resets[history_num_in]) {
    wattron(title_win,A_REVERSE);
    mvwprintw(title_win,1,(COLS/2)-3,"RESET");
    wattroff(title_win,A_REVERSE);
  }
  else if (done_time != 0 && (history_num_in == done_time)) {
    wattron(title_win,A_REVERSE);
    mvwprintw(title_win,1,(COLS/2)-3,"DONE ");
    wattroff(title_win,A_REVERSE);
  }
  else
    mvwprintw(title_win,1,(COLS/2)-3,"     ");
  wrefresh(title_win);


  // Handle updating the ARF window
  for (i=0; i < NUM_ARF; i++) {
    if (strncmp(arf_contents[history_num_in]+i*20,
                arf_contents[old_history_num_in]+i*20,20))
      wattron(arf_win, A_REVERSE);
    else
      wattroff(arf_win, A_REVERSE);
    mvwaddnstr(arf_win,i+1,6,arf_contents[history_num_in]+i*20,20);
  }
  wrefresh(arf_win);


  // Handle updating the IF window
  for(i=0;i<num_if_id_regs;i++){
    if (strcmp(if_id_contents[history_num_in][i],
                if_id_contents[old_history_num_in][i]))
      wattron(if_id_win, A_REVERSE);
    else
      wattroff(if_id_win, A_REVERSE);
    mvwaddstr(if_id_win,i+1,strlen(if_id_reg_names[i])+3,if_id_contents[history_num_in][i]);
  }
  wrefresh(if_id_win);

  // Handle updating the IF/ID window
  for(i=0;i<num_pr_regs;i++){
    if (strcmp(pr_contents[history_num_in][i],
                pr_contents[old_history_num_in][i]))
      wattron(pr_win, A_REVERSE);
    else
      wattroff(pr_win, A_REVERSE);
    mvwaddstr(pr_win,i+1,strlen(pr_reg_names[i])+3,pr_contents[history_num_in][i]);
  }
  wrefresh(pr_win);

  // Handle updating the ID window
  for(i=0;i<num_rs_regs;i++){
    if (strcmp(rs_contents[history_num_in][i],
                rs_contents[old_history_num_in][i]))
      wattron(rs_win, A_REVERSE);
    else
      wattroff(rs_win, A_REVERSE);
    mvwaddstr(rs_win,i+1,strlen(rs_reg_names[i])+3,rs_contents[history_num_in][i]);
  }
  wrefresh(rs_win);


  // Handle updating the ID/EX window
  for(i=0;i<num_ex_pipe_regs;i++){
    if (strcmp(ex_pipe_contents[history_num_in][i],
                ex_pipe_contents[old_history_num_in][i]))
      wattron(ex_pipe_win, A_REVERSE);
    else
      wattroff(ex_pipe_win, A_REVERSE);
    mvwaddstr(ex_pipe_win,i+1,strlen(ex_pipe_reg_names[i])+3,ex_pipe_contents[history_num_in][i]);
  }
  wrefresh(ex_pipe_win);

  // Handle updating the EX window
  for(i=0;i<num_rc_regs;i++){
    if (strcmp(rc_contents[history_num_in][i],
                rc_contents[old_history_num_in][i]))
      wattron(rc_win, A_REVERSE);
    else
      wattroff(rc_win, A_REVERSE);
    mvwaddstr(rc_win,i+1,strlen(rc_reg_names[i])+3,rc_contents[history_num_in][i]);
  }
  wrefresh(rc_win);

  // Handle updating the EX/MEM window
  for(i=0;i<num_lq_sq_regs;i++){
    if (strcmp(lq_sq_contents[history_num_in][i],
                lq_sq_contents[old_history_num_in][i]))
      wattron(lq_sq_win, A_REVERSE);
    else
      wattroff(lq_sq_win, A_REVERSE);
    mvwaddstr(lq_sq_win,i+1,strlen(lq_sq_reg_names[i])+3,lq_sq_contents[history_num_in][i]);
  }
  wrefresh(lq_sq_win);

  // Handle updating the MEM window
  for(i=0;i<num_mem_regs;i++){
    if (strcmp(mem_contents[history_num_in][i],
                mem_contents[old_history_num_in][i]))
      wattron(mem_win, A_REVERSE);
    else
      wattroff(mem_win, A_REVERSE);
    mvwaddstr(mem_win,i+1,strlen(mem_reg_names[i])+3,mem_contents[history_num_in][i]);
  }
  wrefresh(mem_win);

  // Handle updating the MEM/WB window
  for(i=0;i<num_id_cache_regs;i++){
    if (strcmp(id_cache_contents[history_num_in][i],
                id_cache_contents[old_history_num_in][i]))
      wattron(id_cache_win, A_REVERSE);
    else
      wattroff(id_cache_win, A_REVERSE);
    mvwaddstr(id_cache_win,i+1,strlen(id_cache_reg_names[i])+3,id_cache_contents[history_num_in][i]);
  }
  wrefresh(id_cache_win);

  // Handle updating the WB window
  for(i=0;i<num_cache_control_regs;i++){
    if (strcmp(cache_control_contents[history_num_in][i],
                cache_control_contents[old_history_num_in][i]))
      wattron(cache_control_win, A_REVERSE);
    else
      wattroff(cache_control_win, A_REVERSE);
    mvwaddstr(cache_control_win,i+1,strlen(cache_control_reg_names[i])+3,cache_control_contents[history_num_in][i]);
  }
  wrefresh(cache_control_win);

  // Handle updating the misc. window
  int row=1,col=1;
  for (i=0;i<num_misc_regs;i++){
    if (strcmp(misc_contents[history_num_in][i],
                misc_contents[old_history_num_in][i]))
      wattron(misc_win, A_REVERSE);
    else
      wattroff(misc_win, A_REVERSE);
    

    mvwaddstr(misc_win,i+1,strlen(misc_reg_names[i])+3,misc_contents[history_num_in][i]);
  }
  wrefresh(misc_win);

  //update the time window
  mvwaddstr(time_win,1,1,timebuffer[history_num_in]);
  wrefresh(time_win);

  //update to the correct clock edge for this history
  mvwaddstr(clock_win,1,7,cycles[history_num_in]);
  update_clock(clocks[history_num_in]);

  //save the old history index to check for changes later
  old_history_num_in = history_num_in;
}

// Parse a line of data output from the testbench
int processinput(){
  static int byte_num = 0;
  static int if_id_reg_num = 0;
  static int pr_reg_num = 0;
  static int rs_reg_num = 0;
  static int ex_pipe_reg_num = 0;
  static int rc_reg_num = 0;
  static int lq_sq_reg_num = 0;
  static int mem_reg_num = 0;
  static int id_cache_reg_num = 0;
  static int cache_control_reg_num = 0;
  static int misc_reg_num = 0;
  int tmp_len;
  char name_buf[32];
  char val_buf[32];

  //get rid of newline character
  readbuffer[strlen(readbuffer)-1] = 0;

  if(strncmp(readbuffer,"t",1) == 0){

    //We are getting the timestamp
    strcpy(timebuffer[history_num],readbuffer+1);
  }else if(strncmp(readbuffer,"c",1) == 0){

    //We have a clock edge/cycle count signal
    if(strncmp(readbuffer+1,"0",1) == 0)
      clocks[history_num] = 0;
    else
      clocks[history_num] = 1;

    // grab clock count (for some reason, first clock count sent is
    // too many digits, so check for this)
    strncpy(cycles[history_num],readbuffer+2,7);
    if (strncmp(cycles[history_num],"       ",7) == 0)
      cycles[history_num][6] = '0';
    
  }else if(strncmp(readbuffer,"z",1) == 0){
    
    // we have a reset signal
    if(strncmp(readbuffer+1,"0",1) == 0)
      resets[history_num] = 0;
    else
      resets[history_num] = 1;

  }else if(strncmp(readbuffer,"a",1) == 0){
    // We are getting ARF registers
    strcpy(arf_contents[history_num], readbuffer+1);

  }else if(strncmp(readbuffer,"p",1) == 0){
    // We are getting information about which instructions are in each stage
    strcpy(inst_contents[history_num], readbuffer+1);

  }else if(strncmp(readbuffer,"f",1) == 0){
    // We are getting an IF register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, if_id_reg_num, if_id_contents, if_id_reg_names);
      mvwaddstr(if_id_win,if_id_reg_num+1,1,if_id_reg_names[if_id_reg_num]);
      waddstr(if_id_win, ": ");
      wrefresh(if_id_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(if_id_contents[history_num][if_id_reg_num],val_buf);
    }

    if_id_reg_num++;
  }else if(strncmp(readbuffer,"g",1) == 0){
    // We are getting an IF/ID register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, pr_reg_num, pr_contents, pr_reg_names);
      mvwaddstr(pr_win,pr_reg_num+1,1,pr_reg_names[pr_reg_num]);
      waddstr(pr_win, ": ");
      wrefresh(pr_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(pr_contents[history_num][pr_reg_num],val_buf);
    }

    pr_reg_num++;
  }else if(strncmp(readbuffer,"d",1) == 0){
    // We are getting an ID register
    
    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, rs_reg_num, rs_contents, rs_reg_names);
      mvwaddstr(rs_win,rs_reg_num+1,1,rs_reg_names[rs_reg_num]);
      waddstr(rs_win, ": ");
      wrefresh(rs_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_contents[history_num][rs_reg_num],val_buf);
    }

    rs_reg_num++;
  }else if(strncmp(readbuffer,"h",1) == 0){
    // We are getting an ID/EX register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, ex_pipe_reg_num, ex_pipe_contents, ex_pipe_reg_names);
      mvwaddstr(ex_pipe_win,ex_pipe_reg_num+1,1,ex_pipe_reg_names[ex_pipe_reg_num]);
      waddstr(ex_pipe_win, ": ");
      wrefresh(ex_pipe_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(ex_pipe_contents[history_num][ex_pipe_reg_num],val_buf);
    }

    ex_pipe_reg_num++;
  }else if(strncmp(readbuffer,"e",1) == 0){
    // We are getting an EX register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, rc_reg_num, rc_contents, rc_reg_names);
      mvwaddstr(rc_win,rc_reg_num+1,1,rc_reg_names[rc_reg_num]);
      waddstr(rc_win, ": ");
      wrefresh(rc_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rc_contents[history_num][rc_reg_num],val_buf);
    }

    rc_reg_num++;
  }else if(strncmp(readbuffer,"i",1) == 0){
    // We are getting an EX/MEM register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, lq_sq_reg_num, lq_sq_contents, lq_sq_reg_names);
      mvwaddstr(lq_sq_win,lq_sq_reg_num+1,1,lq_sq_reg_names[lq_sq_reg_num]);
      waddstr(lq_sq_win, ": ");
      wrefresh(lq_sq_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(lq_sq_contents[history_num][lq_sq_reg_num],val_buf);
    }

    lq_sq_reg_num++;
  }else if(strncmp(readbuffer,"m",1) == 0){
    // We are getting a MEM register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, mem_reg_num, mem_contents, mem_reg_names);
      mvwaddstr(mem_win,mem_reg_num+1,1,mem_reg_names[mem_reg_num]);
      waddstr(mem_win, ": ");
      wrefresh(mem_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(mem_contents[history_num][mem_reg_num],val_buf);
    }

    mem_reg_num++;
  }else if(strncmp(readbuffer,"j",1) == 0){
    // We are getting an MEM/WB register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, id_cache_reg_num, id_cache_contents, id_cache_reg_names);
      mvwaddstr(id_cache_win,id_cache_reg_num+1,1,id_cache_reg_names[id_cache_reg_num]);
      waddstr(id_cache_win, ": ");
      wrefresh(id_cache_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(id_cache_contents[history_num][id_cache_reg_num],val_buf);
    }

    id_cache_reg_num++;
  }else if(strncmp(readbuffer,"w",1) == 0){
    // We are getting a WB register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, cache_control_reg_num, cache_control_contents, cache_control_reg_names);
      mvwaddstr(cache_control_win,cache_control_reg_num+1,1,cache_control_reg_names[cache_control_reg_num]);
      waddstr(cache_control_win, ": ");
      wrefresh(cache_control_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(cache_control_contents[history_num][cache_control_reg_num],val_buf);
    }

    cache_control_reg_num++;
  }else if(strncmp(readbuffer,"v",1) == 0){

    //we are processing misc register/wire data
    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, misc_reg_num, misc_contents, misc_reg_names);
      mvwaddstr(misc_win,misc_reg_num+1,1,misc_reg_names[misc_reg_num]);
      waddstr(misc_win, ": ");
      wrefresh(misc_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(misc_contents[history_num][misc_reg_num],val_buf);
    }

    misc_reg_num++;
  }else if (strncmp(readbuffer,"break",4) == 0) {
    // If this is the first time through, indicate that we've setup all of
    // the register arrays.
    setup_registers = 1;

    //we've received our last data segment, now go process it
    byte_num = 0;
    if_id_reg_num = 0;
    pr_reg_num = 0;
    rs_reg_num = 0;
    ex_pipe_reg_num = 0;
    rc_reg_num = 0;
    lq_sq_reg_num = 0;
    mem_reg_num = 0;
    id_cache_reg_num = 0;
    cache_control_reg_num = 0;
    misc_reg_num = 0;

    //update the simulator time, this won't change with 'b's
    mvwaddstr(sim_time_win,1,1,timebuffer[history_num]);
    wrefresh(sim_time_win);

    //tell the parent application we're ready to move on
    return(1); 
  }
  return(0);
}

//this initializes a ncurses window and sets up the arrays for exchanging reg information
void initcurses(int if_id_regs, int pr_regs, int rs_regs, int ex_pipe_regs, int rc_regs,
                int lq_sq_regs, int mem_regs, int id_cache_regs, int cache_control_regs,
                int misc_regs){
  int nbytes;
  int ready_val;

  done_state = 0;
  echo_data = 1;
  num_misc_regs = misc_regs;
  num_if_id_regs = if_id_regs;
  num_pr_regs = pr_regs;
  num_rs_regs = rs_regs;
  num_ex_pipe_regs = ex_pipe_regs;
  num_rc_regs = rc_regs;
  num_lq_sq_regs = lq_sq_regs;
  num_mem_regs = mem_regs;
  num_id_cache_regs = id_cache_regs;
  num_cache_control_regs = cache_control_regs;
  pid_t childpid;
  pipe(readpipe);
  pipe(writepipe);
  stdout_save = dup(1);
  childpid = fork();
  if(childpid == 0){
    close(PARENT_WRITE);
    close(PARENT_READ);
    fp = fdopen(CHILD_READ, "r");
    fp2 = fopen("program.out","w");

    //allocate room on the heap for the reg data
    inst_contents     = (char**) malloc(NUM_HISTORY*sizeof(char*));
    arf_contents      = (char**) malloc(NUM_HISTORY*sizeof(char*));
    int i=0;
    if_id_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    pr_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    ex_pipe_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rc_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    lq_sq_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    mem_contents      = (char***) malloc(NUM_HISTORY*sizeof(char**));
    id_cache_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    cache_control_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    misc_contents     = (char***) malloc(NUM_HISTORY*sizeof(char**));
    timebuffer        = (char**) malloc(NUM_HISTORY*sizeof(char*));
    cycles            = (char**) malloc(NUM_HISTORY*sizeof(char*));
    clocks            = (char*) malloc(NUM_HISTORY*sizeof(char));
    resets            = (char*) malloc(NUM_HISTORY*sizeof(char));

    // allocate room for the register names (what is displayed)
    if_id_reg_names      = (char**) malloc(num_if_id_regs*sizeof(char*));
    pr_reg_names   = (char**) malloc(num_pr_regs*sizeof(char*));
    rs_reg_names      = (char**) malloc(num_rs_regs*sizeof(char*));
    ex_pipe_reg_names   = (char**) malloc(num_ex_pipe_regs*sizeof(char*));
    rc_reg_names      = (char**) malloc(num_rc_regs*sizeof(char*));
    lq_sq_reg_names  = (char**) malloc(num_lq_sq_regs*sizeof(char*));
    mem_reg_names     = (char**) malloc(num_mem_regs*sizeof(char*));
    id_cache_reg_names  = (char**) malloc(num_id_cache_regs*sizeof(char*));
    cache_control_reg_names      = (char**) malloc(num_cache_control_regs*sizeof(char*));
    misc_reg_names    = (char**) malloc(num_misc_regs*sizeof(char*));

    int j=0;
    for(;i<NUM_HISTORY;i++){
      timebuffer[i]       = (char*) malloc(8);
      cycles[i]           = (char*) malloc(7);
      inst_contents[i]    = (char*) malloc(NUM_STAGES*10);
      arf_contents[i]     = (char*) malloc(NUM_ARF*20);
      if_id_contents[i]      = (char**) malloc(num_if_id_regs*sizeof(char*));
      pr_contents[i]   = (char**) malloc(num_pr_regs*sizeof(char*));
      rs_contents[i]      = (char**) malloc(num_rs_regs*sizeof(char*));
      ex_pipe_contents[i]   = (char**) malloc(num_ex_pipe_regs*sizeof(char*));
      rc_contents[i]      = (char**) malloc(num_rc_regs*sizeof(char*));
      lq_sq_contents[i]  = (char**) malloc(num_lq_sq_regs*sizeof(char*));
      mem_contents[i]     = (char**) malloc(num_mem_regs*sizeof(char*));
      id_cache_contents[i]  = (char**) malloc(num_id_cache_regs*sizeof(char*));
      cache_control_contents[i]      = (char**) malloc(num_cache_control_regs*sizeof(char*));
      misc_contents[i]    = (char**) malloc(num_misc_regs*sizeof(char*));
    }
    setup_gui(fp);

    // Main loop for retrieving data and taking commands from user
    char quit_flag = 0;
    char resp=0;
    char running=0;
    int mem_addr=0;
    char goto_flag = 0;
    char cycle_flag = 0;
    char done_received = 0;
    memset(readbuffer,'\0',sizeof(readbuffer));
    while(!quit_flag){
      if (!done_received) {
        fgets(readbuffer, sizeof(readbuffer), fp);
        ready_val = processinput();
      }
      if(strcmp(readbuffer,"DONE") == 0) {
        done_received = 1;
        done_time = history_num - 1;
      }
      if(ready_val == 1 || done_received == 1){
        if(echo_data == 0 && done_received == 1) {
          running = 0;
          timeout(-1);
          echo_data = 1;
          history_num--;
          history_num%=NUM_HISTORY;
        }
        if(echo_data != 0){
          parsedata(history_num);
        }
        history_num++;
        // keep track of whether time wrapped around yet
        if (history_num == NUM_HISTORY)
          time_wrapped = 1;
        history_num%=NUM_HISTORY;

        //we're done reading the reg values for this iteration
        if (done_received != 1) {
          write(CHILD_WRITE, "n", 1);
          write(CHILD_WRITE, &mem_addr, 2);
        }
        char continue_flag = 0;
        int hist_num_temp = (history_num-1)%NUM_HISTORY;
        if (history_num==0) hist_num_temp = NUM_HISTORY-1;
        char echo_data_tmp,continue_flag_tmp;

        while(continue_flag == 0){
          resp=getch();
          if(running == 1){
            continue_flag = 1;
          }
          if(running == 0 || resp == 'p'){ 
            if(resp == 'n' && hist_num_temp == (history_num-1)%NUM_HISTORY){
              if (!done_received)
                continue_flag = 1;
            }else if(resp == 'n'){
              //forward in time, but not up to present yet
              hist_num_temp++;
              hist_num_temp%=NUM_HISTORY;
              parsedata(hist_num_temp);
            }else if(resp == 'r'){
              echo_data = 0;
              running = 1;
              timeout(0);
              continue_flag = 1;
            }else if(resp == 'p'){
              echo_data = 1;
              timeout(-1);
              running = 0;
              parsedata(hist_num_temp);
            }else if(resp == 'q'){
              //quit
              continue_flag = 1;
              quit_flag = 1;
            }else if(resp == 'b'){
              //We're goin BACK IN TIME, woohoo!
              // Make sure not to wrap around to NUM_HISTORY-1 if we don't have valid
              // data there (time_wrapped set to 1 when we wrap around to history 0)
              if (hist_num_temp > 0) {
                hist_num_temp--;
                parsedata(hist_num_temp);
              } else if (time_wrapped == 1) {
                hist_num_temp = NUM_HISTORY-1;
                parsedata(hist_num_temp);
              }
            }else if(resp == 'g' || resp == 'c'){
              // See if user wants to jump to clock cycle instead of sim time
              cycle_flag = (resp == 'c');

              // go to specified simulation time (either in history or
              // forward in simulation time).
              stop_time = get_time();
              
              // see if we already have that time in history
              int tmp_time;
              int cur_time;
              int delta;
              if (cycle_flag)
                sscanf(cycles[hist_num_temp], "%u", &cur_time);
              else
                sscanf(timebuffer[hist_num_temp], "%u", &cur_time);
              delta = (stop_time > cur_time) ? 1 : -1;
              if ((hist_num_temp+delta)%NUM_HISTORY != history_num) {
                tmp_time=hist_num_temp;
                i= (hist_num_temp+delta >= 0) ? (hist_num_temp+delta)%NUM_HISTORY : NUM_HISTORY-1;
                while (i!=history_num) {
                  if (cycle_flag)
                    sscanf(cycles[i], "%u", &cur_time);
                  else
                    sscanf(timebuffer[i], "%u", &cur_time);
                  if ((delta == 1 && cur_time >= stop_time) ||
                      (delta == -1 && cur_time <= stop_time)) {
                    hist_num_temp = i;
                    parsedata(hist_num_temp);
                    stop_time = 0;
                    break;
                  }

                  if ((i+delta) >=0)
                    i = (i+delta)%NUM_HISTORY;
                  else {
                    if (time_wrapped == 1)
                      i = NUM_HISTORY - 1;
                    else {
                      parsedata(hist_num_temp);
                      stop_time = 0;
                      break;
                    }
                  }
                }
              }

              // If we looked backwards in history and didn't find stop_time
              // then give up
              if (i==history_num && (delta == -1 || done_received == 1))
                stop_time = 0;

              // Set flags so that we run forward in the simulation until
              // it either ends, or we hit the desired time
              if (stop_time > 0) {
                // grab current values
                echo_data = 0;
                running = 1;
                timeout(0);
                continue_flag = 1;
                goto_flag = 1;
              }
            }
          }
        }
        // if we're instructed to goto specific time, see if we're there
        int cur_time=0;
        if (goto_flag==1) {
          if (cycle_flag)
            sscanf(cycles[hist_num_temp], "%u", &cur_time);
          else
            sscanf(timebuffer[hist_num_temp], "%u", &cur_time);
          if ((cur_time >= stop_time) ||
              (strcmp(readbuffer,"DONE")==0) ) {
            goto_flag = 0;
            echo_data = 1;
            running = 0;
            timeout(-1);
            continue_flag = 0;
            //parsedata(hist_num_temp);
          }
        }
      }
    }
    refresh();
    delwin(title_win);
    endwin();
    fflush(stdout);
    if(resp == 'q'){
      fclose(fp2);
      write(CHILD_WRITE, "Z", 1);
      exit(0);
    }
    readbuffer[0] = 0;
    while(strncmp(readbuffer,"DONE",4) != 0){
      if(fgets(readbuffer, sizeof(readbuffer), fp) != NULL)
        fputs(readbuffer, fp2);
    }
    fclose(fp2);
    fflush(stdout);
    write(CHILD_WRITE, "Z", 1);
    printf("Child Done Execution\n");
    exit(0);
  } else {
    close(CHILD_READ);
    close(CHILD_WRITE);
    dup2(PARENT_WRITE, 1);
    close(PARENT_WRITE);
    
  }
}


// Function to make testbench block until debugger is ready to proceed
int waitforresponse(){
  static int mem_start = 0;
  char c=0;
  while(c!='n' && c!='Z') read(PARENT_READ,&c,1);
  if(c=='Z') exit(0);
  mem_start = read(PARENT_READ,&c,1);
  mem_start = mem_start << 8 + read(PARENT_READ,&c,1);
  return(mem_start);
}

void flushpipe(){
  char c=0;
  read(PARENT_READ, &c, 1);
}

// Function to return string representation of opcode given inst encoding
char *get_opcode_str(int inst, int valid_inst)
{
  int opcode, check;
  char *str;
  
  if (valid_inst == ((int)'x' - (int)'0'))
    str = "-";
  else if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = (inst >> 26) & 0x0000003f;
    check = (inst>>5) & 0x0000007f;
    switch(opcode)
    {
      case 0x00: str = (inst == 0x555) ? "halt" : "call_pal"; break;
      case 0x08: str = "lda"; break;
      case 0x09: str = "ldah"; break;
      case 0x0a: str = "ldbu"; break;
      case 0x0b: str = "ldqu"; break;
      case 0x0c: str = "ldwu"; break;
      case 0x0d: str = "stw"; break;
      case 0x0e: str = "stb"; break;
      case 0x0f: str = "stqu"; break;
      case 0x10: // INTA_GRP
         switch(check)
         {
           case 0x00: str = "addl"; break;
           case 0x02: str = "s4addl"; break;
           case 0x09: str = "subl"; break;
           case 0x0b: str = "s4subl"; break;
           case 0x0f: str = "cmpbge"; break;
           case 0x12: str = "s8addl"; break;
           case 0x1b: str = "s8subl"; break;
           case 0x1d: str = "cmpult"; break;
           case 0x20: str = "addq"; break;
           case 0x22: str = "s4addq"; break;
           case 0x29: str = "subq"; break;
           case 0x2b: str = "s4subq"; break;
           case 0x2d: str = "cmpeq"; break;
           case 0x32: str = "s8addq"; break;
           case 0x3b: str = "s8subq"; break;
           case 0x3d: str = "cmpule"; break;
           case 0x40: str = "addlv"; break;
           case 0x49: str = "sublv"; break;
           case 0x4d: str = "cmplt"; break;
           case 0x60: str = "addqv"; break;
           case 0x69: str = "subqv"; break;
           case 0x6d: str = "cmple"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x11: // INTL_GRP
         switch(check)
         {
           case 0x00: str = "and"; break;
           case 0x08: str = "bic"; break;
           case 0x14: str = "cmovlbs"; break;
           case 0x16: str = "cmovlbc"; break;
           case 0x20: str = "bis"; break;
           case 0x24: str = "cmoveq"; break;
           case 0x26: str = "cmovne"; break;
           case 0x28: str = "ornot"; break;
           case 0x40: str = "xor"; break;
           case 0x44: str = "cmovlt"; break;
           case 0x46: str = "cmovge"; break;
           case 0x48: str = "eqv"; break;
           case 0x61: str = "amask"; break;
           case 0x64: str = "cmovle"; break;
           case 0x66: str = "cmovgt"; break;
           case 0x6c: str = "implver"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x12: // INTS_GRP
         switch(check)
         {
           case 0x02: str = "mskbl"; break;
           case 0x06: str = "extbl"; break;
           case 0x0b: str = "insbl"; break;
           case 0x12: str = "mskwl"; break;
           case 0x16: str = "extwl"; break;
           case 0x1b: str = "inswl"; break;
           case 0x22: str = "mskll"; break;
           case 0x26: str = "extll"; break;
           case 0x2b: str = "insll"; break;
           case 0x30: str = "zap"; break;
           case 0x31: str = "zapnot"; break;
           case 0x32: str = "mskql"; break;
           case 0x34: str = "srl"; break;
           case 0x36: str = "extql"; break;
           case 0x39: str = "sll"; break;
           case 0x3b: str = "insql"; break;
           case 0x3c: str = "sra"; break;
           case 0x52: str = "mskwh"; break;
           case 0x57: str = "inswh"; break;
           case 0x5a: str = "extwh"; break;
           case 0x62: str = "msklh"; break;
           case 0x67: str = "inslh"; break;
           case 0x6a: str = "extlh"; break;
           case 0x72: str = "mskqh"; break;
           case 0x77: str = "insqh"; break;
           case 0x7a: str = "extqh"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x13: // INTM_GRP
         switch(check)
         {
           case 0x00: str = "mull"; break;
           case 0x20: str = "mulq"; break;
           case 0x30: str = "umulh"; break;
           case 0x40: str = "mullv"; break;
           case 0x60: str = "mulqv"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x14: str = "itfp"; break; // unimplemented
      case 0x15: str = "fltv"; break; // unimplemented
      case 0x16: str = "flti"; break; // unimplemented
      case 0x17: str = "fltl"; break; // unimplemented
      case 0x1a: str = "jsr"; break;
      case 0x1c: str = "ftpi"; break;
      case 0x20: str = "ldf"; break;
      case 0x21: str = "ldg"; break;
      case 0x22: str = "lds"; break;
      case 0x23: str = "ldt"; break;
      case 0x24: str = "stf"; break;
      case 0x25: str = "stg"; break;
      case 0x26: str = "sts"; break;
      case 0x27: str = "stt"; break;
      case 0x28: str = "ldl"; break;
      case 0x29: str = "ldq"; break;
      case 0x2a: str = "ldll"; break;
      case 0x2b: str = "ldql"; break;
      case 0x2c: str = "stl"; break;
      case 0x2d: str = "stq"; break;
      case 0x2e: str = "stlc"; break;
      case 0x2f: str = "stqc"; break;
      case 0x30: str = "br"; break;
      case 0x31: str = "fbeq"; break;
      case 0x32: str = "fblt"; break;
      case 0x33: str = "fble"; break;
      case 0x34: str = "bsr"; break;
      case 0x35: str = "fbne"; break;
      case 0x36: str = "fbge"; break;
      case 0x37: str = "fbgt"; break;
      case 0x38: str = "blbc"; break;
      case 0x39: str = "beq"; break;
      case 0x3a: str = "blt"; break;
      case 0x3b: str = "ble"; break;
      case 0x3c: str = "blbs"; break;
      case 0x3d: str = "bne"; break;
      case 0x3e: str = "bge"; break;
      case 0x3f: str = "bgt"; break;
      default: str = "invalid"; break;
    }
  }

  return str;
}

// Function to parse register $display() from testbench and add to
// names/contents arrays
void parse_register(char *readbuf, int reg_num, char*** contents, char** reg_names) {
  char name_buf[32];
  char val_buf[32];
  int tmp_len;

  sscanf(readbuf,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
  int i=0;
  for (;i<NUM_HISTORY;i++){
    contents[i][reg_num] = (char*) malloc((tmp_len+1)*sizeof(char));
  }
  strcpy(contents[history_num][reg_num],val_buf);
  reg_names[reg_num] = (char*) malloc((strlen(name_buf)+1)*sizeof(char));
  strncpy(reg_names[reg_num], readbuf+1, strlen(name_buf));
  reg_names[reg_num][strlen(name_buf)] = '\0';
}

// Ask user for simulation time to stop at
// Since the enter key isn't detected, user must press 'g' key
//  when finished entering a number.
int get_time() {
  int col = COLS/2-6;
  wattron(title_win,A_REVERSE);
  mvwprintw(title_win,1,col,"goto time: ");
  wrefresh(title_win);
  int resp=0;
  int ptr = 0;
  char buf[32];
  int i;
  
  resp=wgetch(title_win);
  while(resp != 'g' && resp != KEY_ENTER && resp != ERR && ptr < 6) {
    if (isdigit((char)resp)) {
      waddch(title_win,(char)resp);
      wrefresh(title_win);
      buf[ptr++] = (char)resp;
    }
    resp=wgetch(title_win);
  }

  // Clean up title window
  wattroff(title_win,A_REVERSE);
  mvwprintw(title_win,1,col,"           ");
  for(i=0;i<ptr;i++)
    waddch(title_win,' ');

  wrefresh(title_win);

  buf[ptr] = '\0';
  return atoi(buf);
}
