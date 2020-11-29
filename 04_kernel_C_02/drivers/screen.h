#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

/* Screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

/* Public kernel API */
void clear_screen();
void kprint_pos_attr(char *message, int col, int row, char attr);
void kprint_pos(char *message, int col, int row);
void kprint_attr(char *message, char attr);
void kprint(char *message);