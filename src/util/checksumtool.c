#include <stdio.h>
#include <stdint.h>
#include <malloc.h>

int main() {
    FILE* file = fopen("mdos.sys", "r+");
    char indata[12];
    fseek(file, 1024, SEEK_SET);
    int read = fread((void*)indata, 1, 12, file); /* read header into buffer */
    if (read < 12)
        return -1;
    int32_t cs = -(ftell(file)+4);
    fseek(file, 0, SEEK_END);
    cs += ftell(file);
    fseek(file, 1028, SEEK_SET);
    fwrite((void*)&cs, 4, 1, file); /* set the length of the code segment */
    fseek(file, 4, SEEK_CUR);
    int32_t checksum = ~((int32_t)indata[0] + (int32_t)indata[4] + (int32_t)indata[8]);
    fwrite((void*)&checksum, 4, 1, file); /* set the checksum */
    fclose(file);
}