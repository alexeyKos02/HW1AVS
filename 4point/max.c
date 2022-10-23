#include <stdio.h>
static int MAX_SIZE = 1000;
static int ARRAY_A[1000];
static int ARRAY_B[1000];

void compare(int n) {
    for (int j = 0; j < n; ++j) {
        if (ARRAY_A[j] > 0) {
            ARRAY_B[j] = 1;
        } else if (ARRAY_A[j] < 0) {
            ARRAY_B[j] = -1;
        } else {
            ARRAY_B[j] = 0;
        }
    }
}
int main(int args, char** argv) {
    int n, result;
    scanf("%d", &n);
    if (n > MAX_SIZE) {
        printf("enter size is too big\n");
        return 0;
    }
    for (int j = 0; j < n; ++j) {
        scanf("%d", &result);
        ARRAY_A[j] = result;
    }
    compare(n);
    for (int j = 0; j < n; ++j) {
        printf("%d", ARRAY_B[j]);
        printf("\n");
    }
    return 0;
}
