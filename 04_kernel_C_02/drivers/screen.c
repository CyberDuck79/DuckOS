#include "screen.h"
#include "ports.h"

/*
**	STATIC PRIVATE FUNCTIONS
*/

/* Private print utilities */
static int get_offset(int col, int row) {
	return 2 * (row * MAX_COLS + col);
}
static int get_offset_row(int offset) {
	return offset / (2 * MAX_COLS);
}
static  int get_offset_col(int offset) {
	return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;
}

/* 
** Use the VGA ports to get the current cursor position
** 1. Ask for high byte of the cursor offset (data 14)
** 2. Ask for low byte (data 15)
*/
static int get_cursor_offset() {
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2; /* Position * size of character cell */
}

/* Similar to get_cursor_offset, but instead of reading we write data */
static void set_cursor_offset(int offset) {
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

/*
** If 'col' and 'row' are negative, we will print at current cursor location
** If 'attr' is zero it will use 'white on black' as default
** Returns the offset of the next character
** Set the video cursor to the returned offset
*/
static int print_char(char c, int col, int row, char attr) {
    unsigned char *vidmem = (unsigned char*) VIDEO_ADDRESS;
    if (!attr)
		attr = WHITE_ON_BLACK;

    /* Error control: print a red 'E' if the coords aren't right */
    if (col >= MAX_COLS || row >= MAX_ROWS) {
        vidmem[2 * MAX_COLS * MAX_ROWS - 2] = 'E';
        vidmem[2 * MAX_COLS * MAX_ROWS - 1] = RED_ON_WHITE;
        return get_offset(col, row);
    }

    int offset;
    if (col >= 0 && row >= 0)
		offset = get_offset(col, row);
    else
		offset = get_cursor_offset();

    if (c == '\n') {
        row = get_offset_row(offset);
        offset = get_offset(0, row + 1);
    } else {
        vidmem[offset] = c;
        vidmem[offset + 1] = attr;
        offset += 2;
    }
    set_cursor_offset(offset);
    return offset;
}

/*
**	PUBLICLY DECLARED FUNCTIONS
*/

void clear_screen() {
    int screen_size = MAX_COLS * MAX_ROWS;
    char *screen = (char*)VIDEO_ADDRESS;

    for (int i = 0; i < screen_size; i++) {
        screen[i * 2] = ' ';
        screen[i * 2 + 1] = WHITE_ON_BLACK;
    }
    set_cursor_offset(get_offset(0, 0));
}

/*
** Print a message with the specified location and attribute
** If col, row, are negative, we will use the current offset
*/
void kprint_pos_attr(char *message, int col, int row, char attr) {
	/* Set cursor if col/row are negative */
    int offset;
    if (col >= 0 && row >= 0)
        offset = get_offset(col, row);
    else {
        offset = get_cursor_offset();
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }

    /* Loop through message and print it */
    int i = 0;
    while (message[i] != 0) {
        offset = print_char(message[i++], col, row, attr);
        /* Compute row/col for next iteration */
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

void kprint_pos(char *message, int col, int row) {
    kprint_pos_attr(message, col, row, 0);
}

void kprint_attr(char *message, char attr) {
    kprint_pos_attr(message, -1, -1, attr);
}

void kprint(char *message) {
    kprint_pos_attr(message, -1, -1, 0);
}

