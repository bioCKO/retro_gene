#!/usr/bin/perl -w

#��Ⱦɫ��ָ��ļ�
use strict;
#blat ��ʽ
while (<>){
	chomp;
	my @infor=split;
	my $chr=$infor[13];
	print "$chr\n";
	open TMP, ">>$chr.blat.by.chr"||die '!';
	print TMP $_,"\n";
	close TMP;
}