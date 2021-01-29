#include<stdio.h>
#define BS 8
#define N 10

void print(int *A,int n){
    for(int i=0; i<n; i++)
        printf("%d ",A[i]);
    printf("\n");
}

__global__ void add_array(int *A, int *B, int n){
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if(i < n) A[i] = A[i] + B[i];
}

int main(void){
    int threadsPerBlock, blocksPerGrid, n, *A, *B, *dA, *dB;
    n=N; threadsPerBlock=BS;
    blocksPerGrid = (n+BS-1)/BS;
    
    A = (int*) malloc(n*sizeof(int));
    B = (int*) malloc(n*sizeof(int));

    for(int i=0; i<n; i++) A[i]=i;
    for(int i=0; i<n; i++) B[i]=i*2;
    print(A, n);
    print(B, n);    

    cudaMalloc((void**)&dA, n*sizeof(int));
    cudaMalloc((void**)&dB, n*sizeof(int));

    cudaMemcpy(dA, A, n*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, n*sizeof(int), cudaMemcpyHostToDevice);

    add_array<<<blocksPerGrid,threadsPerBlock>>>(dA, dB, n);

    cudaMemcpy(A , dA, n*sizeof(int), cudaMemcpyDeviceToHost);

    print(A, n);
 
    cudaFree(dA);
    free(A);

    return 0;
}