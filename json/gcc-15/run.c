#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *f = fopen("sample.json", "r");
    if (!f) { perror("fopen"); return 1; }

    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *data = malloc(fsize + 1);
    fread(data, 1, fsize, f);
    data[fsize] = '\0';
    fclose(f);

    double x = 0, y = 0, z = 0;
    int count = 0;
    char *p = data;

    /* Simple parser: find "x": <num>, "y": <num>, "z": <num> patterns */
    while ((p = strstr(p, "\"x\"")) != NULL) {
        p = strchr(p, ':');
        if (!p) break;
        p++;
        double xv = strtod(p, &p);

        p = strstr(p, "\"y\"");
        if (!p) break;
        p = strchr(p, ':');
        if (!p) break;
        p++;
        double yv = strtod(p, &p);

        p = strstr(p, "\"z\"");
        if (!p) break;
        p = strchr(p, ':');
        if (!p) break;
        p++;
        double zv = strtod(p, &p);

        x += xv;
        y += yv;
        z += zv;
        count++;
    }

    printf("%.8f\n%.8f\n%.8f\n", x / count, y / count, z / count);
    free(data);
    return 0;
}
