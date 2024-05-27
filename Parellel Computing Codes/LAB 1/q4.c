#include"mpi.h"
#include<stdio.h>
int main(int argc, char*argv[])
{
	int rank,size;
	char str[]="HeLLO";
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	if (str[rank]>='a' && str[rank]<='z' )
		str[rank]-=32;
	else
		str[rank]+=32;
	printf("%s\n",str );
	MPI_Finalize();
	return 0;
}