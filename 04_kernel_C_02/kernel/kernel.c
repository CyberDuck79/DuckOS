#include "../drivers/screen.h"

void main()
{
	clear_screen();
	kprint("     __\n");
	kprint(" ___( o)>\n");
	kprint(" \\ <_. )\n");
	kprint("  `----'\n");
	kprint_attr("DuckOS\n", GREEN_ON_BLACK);
    kprint_attr("Quack Quack Human\n", YELLOW_ON_BLACK);
}