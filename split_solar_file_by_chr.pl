#!/usr/bin/perl -w

#��Ⱦɫ��ָ��ļ�
use strict;
#blat ��ʽ
while (<>){
	chomp;
	my @infor=split;
	my $chr=$infor[5];
	open TMP, ">>$chr.solar.by.chr"||die '!';
	print TMP $_,"\n";
	close TMP;
}
