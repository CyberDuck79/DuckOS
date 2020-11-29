void main ()
{
	unsigned char* video_memory = (unsigned char*)0xb8000;
	video_memory[0] = 'D';
	video_memory[1] = 0x0f;
	video_memory[2] = 'u';
	video_memory[3] = 0x0f;
	video_memory[4] = 'c';
	video_memory[5] = 0x0f;
	video_memory[6] = 'k';
	video_memory[7] = 0x0f;
	video_memory[8] = 'O';
	video_memory[9] = 0x0f;
	video_memory[10] = 'S';
	video_memory[11] = 0x0f;
	int i = 12;
	while (i < 256)
	{
		video_memory[i] = ' ';
		video_memory[i + 1] = 0x0f;
		i += 2;
	}
}