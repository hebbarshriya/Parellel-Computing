#include <stdio.h>
#include <cuda_runtime.h>

__global__ void rowPower(int *dArr, int m, int n) {
    int row = (blockIdx.x / n) + 1;
    int mul = 1;
    while(row > 0) {
        mul *= dArr[blockIdx.x];
        row--;
    }
    dArr[blockIdx.x] = mul;
}

int main() {
    int m, n;
    printf("Enter the dimensions of the matrix: ");
    scanf("%d %d", &m, &n);
    int arr[m*n];
    int *dArr;
    printf("Enter the elements of the matrix: ");
    for(int i=0; i<m*n; i++)
        scanf("%d", &arr[i]);
    cudaMalloc(&dArr, m*n*sizeof(int));
    cudaMemcpy(dArr, arr, m*n*sizeof(int), cudaMemcpyHostToDevice);
    rowPower<<<m*n, 1>>>(dArr, m, n);
    cudaMemcpy(arr, dArr, m*n*sizeof(int), cudaMemcpyDeviceToHost);
    printf("Matrix:\n");
    for(int i=0; i<m*n; i++) {
        if(i%n == 0) printf("\n");
        printf("%d ", arr[i]);
    }
    cudaFree(dArr);
    return 0;
}