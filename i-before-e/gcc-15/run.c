#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int is_valid(const char *s) {
    const char *p = s;
    while ((p = strstr(p, "ei")) != NULL) {
        if (p > s && *(p - 1) == 'c') {
            p += 2;
            continue;
        }
        return 0;
    }
    return 1;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <wordlist>\n", argv[0]);
        return 1;
    }
    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("fopen");
        return 1;
    }
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        size_t len = strlen(line);
        if (len > 0 && line[len-1] == '\n') line[len-1] = '\0';
        if (!is_valid(line)) {
            puts(line);
        }
    }
    fclose(f);
    return 0;
}
