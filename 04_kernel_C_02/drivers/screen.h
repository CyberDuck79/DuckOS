#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// Colors attribute
#define WHITE_ON_BLACK 0x0f
#define BLUE_ON_BLACK 0x01
#define GREEN_ON_BLACK 0x02
#define CYAN_ON_BLACK 0x03
#define RED_ON_BLACK 0x04
#define MAGENTA_ON_BLACK 0x05
#define ORANGE_ON_BLACK 0x06
#define LIGHT_GREY_ON_BLACK 0x07
#define DARK_GREY_ON_BLACK 0x08
#define PURPLE_ON_BLACK 0x09
#define LIGHT_GREEN_ON_BLACK 0x0A
// CONTINUE EXPLORE PALETTE
#define YELLOW_ON_BLACK 0x0E
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