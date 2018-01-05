#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
//#include "util/chk_time.h"

//#define _MACH

#define MAX_PAIMIAN 43//9个条+9个万+9个筒+东南西北中发白春夏秋冬梅竹兰菊
#define PAIMIAN 0
#define COUNT 1

const char scheme[] = {(char)0,(char)8,(char)12,(char)14,(char)15};

struct mahjongs {
	char  mahjong[MAX_PAIMIAN][2]; //按牌面由小到大排放的麻将 [0]表示牌面，[1]表示数量
	char *idx[MAX_PAIMIAN];        //牌面到mahjong的索引
	char  count; 
};

void Add(struct mahjongs *mj,char paimian,char count) {
	mj->mahjong[mj->count][PAIMIAN] = paimian;
	mj->mahjong[mj->count][COUNT] = count;
	mj->idx[paimian] = (char*)&mj->mahjong[mj->count];
	++mj->count;
}

//移除一个刻子
int RemoveKe(struct mahjongs *mj) {
	for(int i = 0;i < mj->count; ++i) {
		if(mj->mahjong[i][COUNT] >= 3) {
			mj->mahjong[i][COUNT] -= 3;
			return 1;
		} 
	}
	return 0;
}

//移除一个顺子
int RemoveSun(struct mahjongs *mj) {
	for(int i = 0;i < mj->count; ++i) {
		if(mj->mahjong[i][COUNT] > 0) {
			char  *next = mj->idx[mj->mahjong[i][PAIMIAN] + 1];
			char  *next_next = mj->idx[mj->mahjong[i][PAIMIAN] + 2];
			if(next && next_next && next[COUNT] > 0 && next_next[COUNT] > 0){
				mj->mahjong[i][COUNT] -= 1;
				next[COUNT] -= 1;
				next_next[COUNT] -= 1;
				return 1;
			} 
		}
	}
	return 0;
}

typedef int (*rFunc)(struct mahjongs *);

int CheckScheme(char s,struct mahjongs *mj) {
	static struct mahjongs g_pais[MAX_PAIMIAN];
	rFunc f[2] = {RemoveKe,RemoveSun};
	int j = 0;
	for(int i = 0; i < mj->count; ++i) {
		if(mj->mahjong[i][COUNT] >= 2) {
			struct mahjongs *pp = &g_pais[j++];
			memset(pp,0,sizeof(*pp));			
			for(int i = 0; i < mj->count; ++i) {
				Add(pp,mj->mahjong[i][PAIMIAN],mj->mahjong[i][COUNT]);
			}
			char *jiang = pp->idx[mj->mahjong[i][PAIMIAN]];
			jiang[COUNT] -= 2;
			int ok = 1;
			for(int i = 0; i < 4; ++i) {
				int b = ((1 << i) & s) == 0 ? 0:1;
				if(!f[b](pp)) {
					ok = 0;
					break;
				}
			}
			if(ok) {
				return 1;
			}
		}
	}
	return 0;
}

int CheckHu(char p[14]) {
	char  pp[MAX_PAIMIAN][2] = {0};
	for(int i = 0; i < 14; ++i) {
		pp[p[i]][PAIMIAN] = p[i];
		pp[p[i]][COUNT] += 1;
	}
	struct mahjongs ppp = {0};
	for(int i = 0; i < MAX_PAIMIAN; ++i) {
		if(pp[i][PAIMIAN] > 0) {
			Add(&ppp,pp[i][PAIMIAN],pp[i][COUNT]);
		}
	}
	for(char i = 0; i < sizeof(scheme); ++i) {
		if(CheckScheme(scheme[i],&ppp)){
			return 1;
		}
	}
	return 0;	
}

int main() {
	char p1[14] = {1,1,1,2,2,2,3,3,3,4,4,4,5,5};
	char p2[14] = {1,2,3,4,5,6,1,2,3,4,5,6,7,7};
	char p3[14] = {1,1,1,1,2,2,2,2,3,3,3,3,4,4};
	char p4[14] = {1,1,1,2,3,4,5,6,4,5,6,7,8,9};
	char p5[14] = {1,1,1,2,3,2,3,4,3,4,5,7,8,9};
	char p6[14] = {1,1,1,4,5,6,2,3,4,4,5,6,9,9};
	char p7[14] = {1,2,3,4,1,2,3,4,5,5,7,7,9,9};

/*	uint64_t now = chk_systick();

	for(int i = 0; i < 10000; ++i) {
		CheckHu(p1);
		CheckHu(p2);
		CheckHu(p3);
		CheckHu(p4);		
		CheckHu(p5);
		CheckHu(p6);
		CheckHu(p7);		
	}

	printf("time %dms\n",chk_systick() - now);
*/

	printf("%d\n",CheckHu(p1));
	printf("%d\n",CheckHu(p2));
	printf("%d\n",CheckHu(p3));
	printf("%d\n",CheckHu(p4));
	printf("%d\n",CheckHu(p5));
	printf("%d\n",CheckHu(p6));
	printf("%d\n",CheckHu(p7));

	return 0;
}