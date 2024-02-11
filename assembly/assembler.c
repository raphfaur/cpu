#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define GETNEXTARG(argn)                                                       \
  j = 0;                                                                       \
  while (i < 10 && (line[i] != ',' || line[i] != '\n')) {                      \
    arg##argn[j] = line[i];                                                    \
    i++;                                                                       \
    j++;                                                                       \
  }                                                                            \
  i++;

int main(int argc, char *argv[]) {
  if (argc == 1) {
    printf("Please provide an assembly file");
  } else {
    FILE *script;
    script = fopen(argv[1], "r");
    if (script < 0) {
      printf("Can't open file, exiting...");
      return EXIT_FAILURE;
    } else {
      printf("Siccessfully opened file \n");
    };
    char ender = 'a';
    char cursor;

    while (ender != EOF) {
      char line[100];
      int i = 0;
      while ((cursor = getc(script)) != ';' && i < 100) {
        line[i] = cursor;
        i++;
      }

      char op[10];
      char arg1[10] = {0};
      char arg2[10] = {0};
      char arg3[10] = {0};

      i = 0;
      while (i < 10 && line[i] != ' ') {
        op[i] = line[i];
        i++;
      }
      i++;
      int j = 0;

      GETNEXTARG(1);
      GETNEXTARG(2);
      GETNEXTARG(3);

      int imm1 = (arg1[0] == 'R');
      int imm2 = (arg2[0] == 'R');
      int imm3 = (arg2[0] == 'R');

      FILE *flashable;
      flashable = fopen("ram.img", "w");

      char bytecode[32] = {0};

      if (imm2 == 0 && imm3 == 0) {
        bytecode[0] = 0;
        bytecode[1] = 0;
        long rdest = strtol(&arg1[1], ((void *)0), 10);
        snprintf(&bytecode[5], "%b", NULL, rdest);
      }
      if (memcmp(&op, "MOV", 3) == 0) {
      }
      ender = getc(script);
    }
  }
  return EXIT_SUCCESS;
};
