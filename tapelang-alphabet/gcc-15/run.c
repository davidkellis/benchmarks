#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OP_INC 0
#define OP_MOVE 1
#define OP_PRINT 2
#define OP_LOOP 3

typedef struct Op {
    int type;
    int val;
    struct Op *loop;
    int loop_len;
} Op;

typedef struct {
    int *cells;
    int size;
    int pos;
} Tape;

void tape_init(Tape *t) {
    t->size = 1;
    t->cells = calloc(t->size, sizeof(int));
    t->pos = 0;
}

int tape_get(Tape *t) { return t->cells[t->pos]; }

void tape_inc(Tape *t, int val) { t->cells[t->pos] += val; }

void tape_move(Tape *t, int val) {
    t->pos += val;
    while (t->pos >= t->size) {
        int old = t->size;
        t->size *= 2;
        t->cells = realloc(t->cells, t->size * sizeof(int));
        memset(t->cells + old, 0, (t->size - old) * sizeof(int));
    }
    while (t->pos < 0) {
        int old = t->size;
        t->size *= 2;
        int *nc = calloc(t->size, sizeof(int));
        memcpy(nc + old, t->cells, old * sizeof(int));
        free(t->cells);
        t->cells = nc;
        t->pos += old;
    }
}

Op *parse(const char **src, int *count);

Op *parse(const char **src, int *count) {
    int cap = 16;
    Op *ops = malloc(cap * sizeof(Op));
    *count = 0;

    while (**src) {
        char c = **src;
        (*src)++;
        if (c == '+' || c == '-') {
            int val = (c == '+') ? 1 : -1;
            while (**src == c) { val += (c == '+') ? 1 : -1; (*src)++; }
            if (*count >= cap) { cap *= 2; ops = realloc(ops, cap * sizeof(Op)); }
            ops[*count] = (Op){OP_INC, val, NULL, 0};
            (*count)++;
        } else if (c == '>' || c == '<') {
            int val = (c == '>') ? 1 : -1;
            while (**src == c) { val += (c == '>') ? 1 : -1; (*src)++; }
            if (*count >= cap) { cap *= 2; ops = realloc(ops, cap * sizeof(Op)); }
            ops[*count] = (Op){OP_MOVE, val, NULL, 0};
            (*count)++;
        } else if (c == '.') {
            if (*count >= cap) { cap *= 2; ops = realloc(ops, cap * sizeof(Op)); }
            ops[*count] = (Op){OP_PRINT, 0, NULL, 0};
            (*count)++;
        } else if (c == '[') {
            int lc = 0;
            Op *loop = parse(src, &lc);
            if (*count >= cap) { cap *= 2; ops = realloc(ops, cap * sizeof(Op)); }
            ops[*count] = (Op){OP_LOOP, 0, loop, lc};
            (*count)++;
        } else if (c == ']') {
            break;
        }
    }
    return ops;
}

void run(Op *ops, int count, Tape *tape) {
    for (int i = 0; i < count; i++) {
        switch (ops[i].type) {
            case OP_INC: tape_inc(tape, ops[i].val); break;
            case OP_MOVE: tape_move(tape, ops[i].val); break;
            case OP_PRINT: putchar(tape_get(tape)); break;
            case OP_LOOP:
                while (tape_get(tape) != 0)
                    run(ops[i].loop, ops[i].loop_len, tape);
                break;
        }
    }
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "Usage: %s <file>\n", argv[0]); return 1; }
    FILE *f = fopen(argv[1], "r");
    if (!f) { perror("fopen"); return 1; }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *src = malloc(sz + 1);
    fread(src, 1, sz, f);
    src[sz] = '\0';
    fclose(f);

    const char *p = src;
    int count = 0;
    Op *ops = parse(&p, &count);

    Tape tape;
    tape_init(&tape);
    run(ops, count, &tape);

    free(src);
    return 0;
}
