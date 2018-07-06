// Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.c

#include "stdlib.h"
#include "stdio.h"
#include "time.h"
#include <stdint.h>
#include <string.h>
#include <openssl/md5.h>

typedef unsigned int uint;
const char* chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static char decode_table[256];

int encode_size(int size) {
  return (int)(size * 4 / 3.0) + 6;
}

int decode_size(int size) {
  return (int)(size * 3 / 4.0) + 6;
}

void init_decode_table() {
  for (int i = 0; i < 256; i++) {
    char ch = (char)i;
    char code = -1;
    if (ch >= 'A' && ch <= 'Z') code = ch - 0x41;
    if (ch >= 'a' && ch <= 'z') code = ch - 0x47;
    if (ch >= '0' && ch <= '9') code = ch + 0x04; 
    if (ch == '+' || ch == '-') code = 0x3E;
    if (ch == '/' || ch == '_') code = 0x3F;
    decode_table[i] = code;
  }
}

#define next_char(x) char x = decode_table[(unsigned char)*str++]; if (x < 0) return 1;

int decode(int size, const char* str, int* out_size, char** output) {
  *output = (char*) malloc( decode_size(size) );
  char *out = *output;
  while (size > 0 && (str[size - 1] == '\n' || str[size - 1] == '\r' || str[size - 1] == '=')) size--;
  const char* ends = str + size - 4;
  while (1) {
    if (str > ends) break;
    while (*str == '\n' || *str == '\r') str++;

    if (str > ends) break;
    next_char(a); next_char(b); next_char(c); next_char(d);

    *out++ = (char)(a << 2 | b >> 4);
    *out++ = (char)(b << 4 | c >> 2);
    *out++ = (char)(c << 6 | d >> 0);
  }

  int mod = (str - ends) % 4;
  if (mod == 2) {
    next_char(a); next_char(b);
    *out++ = (char)(a << 2 | b >> 4);
  } else if (mod == 3) {
    next_char(a); next_char(b); next_char(c);
    *out++ = (char)(a << 2 | b >> 4);
    *out++ = (char)(b << 4 | c >> 2);
  }

  *out = '\0';
  *out_size = out - *output;
  return 0;
}

void encode(int size, const char* str, int* out_size, char** output) {
  *output = (char*) malloc( encode_size(size) );
  char *out = *output;
  const char* ends = str + (size - size % 3);
  uint n;
  while (str != ends) {
    uint32_t n = __builtin_bswap32(*(uint32_t*)str);
    *out++ = chars[(n >> 26) & 63];
    *out++ = chars[(n >> 20) & 63];
    *out++ = chars[(n >> 14) & 63];
    *out++ = chars[(n >> 8) & 63];
    str += 3;
  }
  int pd = size % 3;
  if  (pd == 1) {
    n = (uint)*str << 16;
    *out++ = chars[(n >> 18) & 63];
    *out++ = chars[(n >> 12) & 63];
    *out++ = '=';
    *out++ = '=';
  } else if (pd == 2) {
    n = (uint)*str++ << 16;
    n |= (uint)*str << 8;
    *out++ = chars[(n >> 18) & 63];
    *out++ = chars[(n >> 12) & 63];
    *out++ = chars[(n >> 6) & 63];
    *out++ = '=';
  }
  *out = '\0';
  *out_size = out - *output;
}

int main() {
  init_decode_table();

  const int STR_SIZE = 1000000;
  const int TRIES = 20;

  int i;
  unsigned char result[MD5_DIGEST_LENGTH];
  char *str;
  int str_size = STR_SIZE;
  char *str2;
  int str2_size;

  str = (char*) malloc(str_size + 1);
  for (i = 0; i < STR_SIZE; i++) { str[i] = 'a'; }
  str[STR_SIZE] = '\0';

  MD5((unsigned char *)str, strlen(str), result);
  for(i = 0; i < MD5_DIGEST_LENGTH; i++)
    printf("%02x", result[i]);
  printf("\n");

  for (i = 0; i < TRIES; i++) { 
    encode(str_size, str, &str2_size, &str2); 
    free(str);
    str = str2;
    str_size = str2_size;
  }

  MD5((unsigned char *)str, strlen(str), result);
  for(i = 0; i < MD5_DIGEST_LENGTH; i++)
    printf("%02x", result[i]);
  printf("\n");

  for (i = 0; i < TRIES; i++) {
    if (decode(str_size, str, &str2_size, &str2) != 0) {
      printf("error when decoding");
    }
    free(str);
    str = str2;
    str_size = str2_size;
  }
  
  MD5((unsigned char *)str, strlen(str), result);
  for(i = 0; i < MD5_DIGEST_LENGTH; i++)
    printf("%02x", result[i]);
  printf("\n");

  free(str);
}