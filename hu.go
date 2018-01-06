package main

import "fmt"
import "time"

const (
	MAX_PAIMIAN = 43//9个条+9个万+9个筒+东南西北中发白春夏秋冬梅竹兰菊
)

var scheme []int8 = []int8{0,8,12,14,15}
type mahjong struct {
	paimian int8
	count   int8
}

type mahjongs struct {
	m     [MAX_PAIMIAN]mahjong
	idx   [MAX_PAIMIAN]*mahjong
	count int8
}

var mahjongs_pool [MAX_PAIMIAN]mahjongs

func (this *mahjongs) Add(paimian int8,count int8) {
	this.m[this.count].paimian = paimian
	this.m[this.count].count = count
	this.idx[paimian] = &this.m[this.count]
	this.count++
}

func (this *mahjongs) RemoveKe() bool {
	for i := int8(0);i < this.count; i++ {
		if this.m[i].count >= 3 {
			this.m[i].count -= 3
			return true
		}
	}
	return false
}

func (this *mahjongs) RemoveSun() bool {
	for i := int8(0);i < this.count; i++ {
		if this.m[i].count > 0 {
			next := this.idx[this.m[i].paimian+1]
			next_next := this.idx[this.m[i].paimian+2]
			if next != nil && next_next != nil && next.count > 0 && next_next.count > 0 {
				this.m[i].count -= 1
				next.count -= 1
				next_next.count -= 1
				return true
			}

		}
	}
	return false
}

func (this *mahjongs) Reset() {
	this.count = 0
	for i := 0;i < MAX_PAIMIAN; i++ {
		this.m[i].paimian = 0
		this.m[i].count = 0
		this.idx[i] = nil
	}
}

func CheckScheme(s int8,mj *mahjongs) bool {

	f := func (i int8,mj *mahjongs) bool {
		if i == 0 {
			return mj.RemoveKe()
		} else {
			return mj.RemoveSun()
		}
	}

	j := 0
	for i := int8(0);i < mj.count; i++ {
		if mj.m[i].count >= 2 {
			pp := &mahjongs_pool[j]
			j++
			pp.Reset()
			for i := int8(0);i < mj.count; i++ {
				pp.Add(mj.m[i].paimian,mj.m[i].count)
			}
			jiang := pp.idx[mj.m[i].paimian]
			jiang.count -= 2
			ok := true
			for i := uint8(0); i < 4; i++ {
				if !f(int8((1 << i) & s),pp) {
					ok = false
					break
				}
			}
			if ok {
				return true
			}
		}
	}
	return false
}

func CheckHu(p [14]int8) bool {
	var pp [MAX_PAIMIAN]mahjong
	for i := 0;i < 14; i++ {
		pp[p[i]].paimian = p[i]
		pp[p[i]].count++
	}

	var ppp mahjongs
	for i := 0; i < MAX_PAIMIAN; i++ {
		if pp[i].paimian > 0 {
			ppp.Add(pp[i].paimian,pp[i].count)
		}
	}
	for i := 0 ; i < len(scheme); i++ {
		if CheckScheme(scheme[i],&ppp) {
			return true
		}
	}
	return false
}

func main() {
	p1 := [14]int8{1,1,1,2,2,2,3,3,3,4,4,4,5,5}
	p2 := [14]int8{1,2,3,4,5,6,1,2,3,4,5,6,7,7}
	p3 := [14]int8{1,1,1,1,2,2,2,2,3,3,3,3,4,4}
	p4 := [14]int8{1,1,1,2,3,4,5,6,4,5,6,7,8,9}
	p5 := [14]int8{1,1,1,2,3,2,3,4,3,4,5,7,8,9}
	p6 := [14]int8{1,1,1,4,5,6,2,3,4,4,5,6,9,9}
	p7 := [14]int8{1,2,3,4,1,2,3,4,5,5,7,7,9,9}


	now := time.Now().UnixNano()/int64(time.Millisecond)
	count := 0

	for i := 0; i < 10000; i++ {
		CheckHu(p1)
		CheckHu(p2)
		CheckHu(p3)
		CheckHu(p4)
		CheckHu(p5)
		CheckHu(p6)
		CheckHu(p7)
		count += 7
	}

	elapse := time.Now().UnixNano()/int64(time.Millisecond) - now

	fmt.Printf("count:%d time:%dms %d per second\n",count,elapse,int64(count*1000)/elapse)

	fmt.Printf("%b\n",CheckHu(p1))
	fmt.Printf("%b\n",CheckHu(p2))
	fmt.Printf("%b\n",CheckHu(p3))
	fmt.Printf("%b\n",CheckHu(p4))
	fmt.Printf("%b\n",CheckHu(p5))
	fmt.Printf("%b\n",CheckHu(p6))
	fmt.Printf("%b\n",CheckHu(p7))

}



	
