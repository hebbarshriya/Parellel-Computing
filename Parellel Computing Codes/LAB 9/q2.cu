#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

__global__ void q1a(int*a, int*b, int* c, int wa, int wb){
	int ridA=threadIdx.x;
	int sum;
	for(int cidB=0;cidB<wb;cidB++){
		sum=0;
		for(int k=0;k<wa;k++){
			sum+=a[ridA*wa + k] * b[k*wb + cidB];
		}
		c[ridA*wb +cidB]=sum;
	}
}

__global__ void q1b(int*a, int*b, int* c ,int ha,int wa){
	int cidB=threadIdx.x;
	int wb=blockDim.x;
	int sum;
	for(int ridA=0;ridA<ha;ridA++){
		sum=0;
		for(int k=0;k<wa;k++){
			sum+=a[ridA*wa + k] * b[k*wb + cidB];
		}
		c[ridA*wb +cidB]=sum;
	}
}

__global__ void q1c(int*a, int*b, int* c ,int wa){
	int cidB=threadIdx.x;
	int ridA=threadIdx.y;
	int wb=blockDim.x;
	int sum=0;
	for(int k=0;k<wa;k++){
		sum+=a[ridA*wa + k] * b[k*wb + cidB];
	}
	c[ridA*wb +cidB]=sum;
	
}

int main(void)
{
	int *a,*b,*c,ha,wa,hb,wb,i,j;
	int *d_a,*d_b,*d_c;
	printf("Enter the value of ha and wa: ");
	scanf("%d %d",&ha,&wa);
	printf("Enter the value of wa and wb: ");
	scanf("%d %d",&hb,&wb);
	
	a=(int*)malloc(ha*wa*sizeof(int));
	b=(int*)malloc(hb*wb*sizeof(int));
	c=(int*)malloc(ha*wb*sizeof(int));

	printf("Enter input matrix A:\n");
	for(i=0;i<ha*wa;i++)
		scanf("%d",&a[i]);
	printf("Enter input matrix B:\n");
	for(i=0;i<hb*wb;i++)
		scanf("%d",&b[i]);

	cudaMalloc((void**)&d_a,sizeof(int)*wa*ha);
	cudaMalloc((void**)&d_b,sizeof(int)*wb*hb);
	cudaMalloc((void**)&d_c,sizeof(int)*wb*ha);

	cudaMemcpy(d_a,a,sizeof(int)*wa*ha,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,b,sizeof(int)*wb*hb,cudaMemcpyHostToDevice);


	q1a<<<1,ha>>>(d_a,d_b,d_c,wa,wb);
	cudaMemcpy(c,d_c,sizeof(int)*wb*ha,cudaMemcpyDeviceToHost);
	printf("Result vector is:\n");
	for(i=0;i<ha;i++){
		for(j=0;j<wb;j++)
			printf("%d\t",c[i*ha+j]);
		printf("\n");
	}

	//q1b<<<1,wb>>>(d_a,d_b,d_c,ha,wa);
	//cudaMemcpy(c,d_c,sizeof(int)*wb*ha,cudaMemcpyDeviceToHost);
	//printf("Result vector is:\n");
	//for(i=0;i<ha;i++){
	//	for(j=0;j<wb;j++)
	//		printf("%d\t",c[i*ha+j]);
	//	printf("\n");
	//}

	//q1c<<<(1,1),(ha,wb)>>>(d_a,d_b,d_c,wa);
	//cudaMemcpy(c,d_c,sizeof(int)*wb*ha,cudaMemcpyDeviceToHost);
	//printf("Result vector is:\n");
	//for(i=0;i<ha;i++){
		//for(j=0;j<wb;j++)
		//	printf("%d\t",c[i*ha+j]);
		//printf("\n");
	//}

getchar();
cudaFree(d_a);
cudaFree(d_b);
cudaFree(d_c);
return 0;
}