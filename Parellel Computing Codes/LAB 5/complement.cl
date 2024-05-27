__kernel void convert_to_octal(__global const int *input, __global int *output, const int n) {
    int gid = get_global_id(0);
    if (gid < n) {
        int num = input[gid];
        int octal = 0, i = 1;
        while (num != 0) {
            octal += (num % 8) * i;
            num /= 8;
            i *= 10;
        }
        output[gid] = octal;
    }
}
