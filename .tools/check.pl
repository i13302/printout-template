#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use Getopt::Long 'GetOptions';
use File::Basename 'basename';

sub ret_ext_change
{
	my ($dstfile,$toext)=@_;
	$dstfile=~s/^(.*)\..*$/$1/;
	return $dstfile.'.'.$toext;
}

sub files_ext_change
{
	my ($ref_files,$toext)=@_;
	foreach(@$ref_files){
		$_=&ret_ext_change($_,$toext)
	}
}

sub trim_dirname
{
	my ($ref_paths)=@_;
	foreach(@$ref_paths){
		$_=&basename($_);
	}
}

sub main
{
	my $work_dir='work';
	my $md_dir  ='markdown';
	my $pdf_dir ='pdf';

	GetOptions(
		'work=s'     =>\$work_dir,
		'markdown=s' =>\$md_dir,
		'pdf=s'      =>\$pdf_dir,
	);

	my @md_path=glob $work_dir.'/'.$md_dir.'/*.md';
	trim_dirname(\@md_path);
	
	my @pdf_path=@md_path;
	files_ext_change(\@pdf_path,'pdf');
	
	my @builed_pdf_path=glob $work_dir.'/'.$pdf_dir.'/*.pdf';
	trim_dirname(\@builed_pdf_path);
	
	my @miss_files=grep {my $t=$_; ! grep /^$t$/, @builed_pdf_path} @pdf_path;
	print Dumper @miss_files;
	return @miss_files;
}

my $STATUS=&main;
exit $STATUS;
