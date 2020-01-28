#!/usr/bin/perl -w

open List, "$ARGV[0]"||die '!';
open Extra, ">$ARGV[1]"||die "!";
open Family,">$ARGV[2]"||die '!';
use strict;

#GSTENP00012901001_1_782938_785013       1       +       475     783479  784270  4       exon_3  792     783479  784270  441  783830   784270
#GSTENP00019881001_1_783830_785013       1       +       251     783830  784270  2       exon_1  441     783830  784270  441  783830   784270

my %overlap_size=();
my %overlap_len=();
my %hash=();
my %tag=();
my %len=();

while (my $line1=<List>) {
	chomp $line1;
	my @infor1=split /\s+/,$line1;
	my $name1=$infor1[0];
	my $strand1=$infor1[2];
	my $line2=<List>;
	chomp $line2;
	my @infor2=split /\s+/,$line2;
	my $name2=$infor2[0];
	my $strand2=$infor2[2];

	$len{"$name1\t$name2"}->[0]=$infor1[3];#ע�⣬����ĳ����Ǻ���ĳ���
	$len{"$name1\t$name2"}->[1]=$infor2[3];

	
	if ($strand1 eq $strand2) {
		$tag{"$name1\t$name2"}++;
	
	if (!exists $hash{"$name1\t$name2"}) {$hash{"$name1\t$name2"}="$line1\n$line2\n";}
	else {$hash{"$name1\t$name2"}.="$line1\n$line2\n";}

	if (!exists $overlap_len{"$name1\t$name2"}) {
		$overlap_len{"$name1\t$name2"}->[0]=$infor1[11];
		$overlap_len{"$name1\t$name2"}->[1]=$infor2[11];
		}
	else {
		$overlap_len{"$name1\t$name2"}->[0]+=$infor1[11];
		$overlap_len{"$name1\t$name2"}->[1]+=$infor2[11];
		}
	}
	else {	
		if (!exists $hash{"$name1\t$name2"}) {$hash{"$name1\t$name2"}="$line1\n$line2\n";}
		else {$hash{"$name1\t$name2"}.="$line1\n$line2\n";}
	}
}
close List;

my %family;
foreach my $key (keys %hash) {#ȥ����,��2����������ͬ����60%�����л���5�����ϵ�exon��overlap,Ӧ������ͬһ����Ĳ�ͬ������ʽ
	my @infor=split /\t/, $key;
	if(!exists $overlap_len{$key}){}
	else {
	if ($overlap_len{$key}->[0]/$len{$key}->[0]>0.6 or $overlap_len{$key}->[1]/$len{$key}->[1]>0.6 ) 
	{
		my $name_1=(split /_/,$infor[0])[0];
		my $name_2=(split /_/,$infor[1])[0];
		#print "$name_1\t$name_2\n";
		if ($name_1 lt $name_2) {$family{"$name_1\t$name_2"}="$name_1\t$name_2";}
		else{$family{"$name_2\t$name_1"}="$name_2\t$name_1";}
		#������ͬһ�����pep����һ��%family�ﲢȥ���ظ���gene�ԣ��ȵ�ͬһλ�õĲ�ͬpep��Ȼ����ͬһ����
		if ($len{$key}->[0]<$len{$key}->[1])
			{
				print Extra "$infor[0]\t$len{$key}->[0]\t$infor[1]\t$len{$key}->[1]\t$overlap_len{$key}->[0]\n";
			}
		else
			{
				print Extra "$infor[1]\t$len{$key}->[1]\t$infor[0]\t$len{$key}->[0]\t$overlap_len{$key}->[0]\n";
			}
	}
	else {#print $overlap_len{$key}->[0],"\t$len{$key}->[0]\t$len{$key}->[1]\n";
		  }
	}
}
foreach my $key (keys %family) {
	print Family "$family{$key}\n";
}