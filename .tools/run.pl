#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use Getopt::Long 'GetOptions';
use File::Basename 'basename';

sub ret_chomp
{
	my $var=shift;
	chomp($var);
	
	return $var
}

sub ret_ext_change
{
	my ($dstfile,$toext)=@_;
	$dstfile=~s/^(.*)\..*$/$1/;
	return $dstfile.'.'.$toext;
}

sub trim_workdir_css_files
{
	my ($work_dir,$ref_css_path)=@_;
	foreach(@$ref_css_path){
		$_=~s/^$work_dir\///;
	}
}

sub docker_cmd_mdtohtml
{
	my ($work_dir,$md_dir,$html_dir,$mdtohtml,$pwd,$md_name,$html_name,$ref_css_path)=@_;
	
	my @cmd=();
	$cmd[0]='docker run --rm --volume "'.$pwd.'/'.$work_dir.':/data" '.$mdtohtml.' \'cd '.$md_dir.'; pandoc -f markdown --self-contained '.$md_name;
	
	$cmd[1]='';
	foreach (@$ref_css_path){
		$cmd[1].='-c ../'.$_.' ';
	}
	
	$cmd[2]='-o ../'.$html_dir.'/'.$html_name.'\'';
	
	return join(' ',@cmd);
}

sub docker_cmd_htmltopdf
{
	my ($work_dir,$html_dir,$pdf_dir,$htmltopdf,$pwd,$html_name,$pdf_name,$tz)=@_;
	my $cmd='docker run --rm -e TZ='.$tz.' --volume "'.$pwd.'/'.$work_dir.':/data" '.$htmltopdf.' "'.$html_dir."/".$html_name.' '.$pdf_dir.'/'.$pdf_name.'"';
	
	return $cmd;
}

sub main
{
	my $work_dir='work';
	my $md_dir  ='markdown';
	my $html_dir='html';
	my $css_dir ='css';
	my $pdf_dir ='pdf';
	my $mdtohtml ='i13302/pandoc';
	my $htmltopdf='i13302/printout';
	my $pwd      =&ret_chomp(`pwd`);
	my $tz       ='Asia/Tokyo';

	GetOptions(
		'work=s'     =>\$work_dir,
		'markdown=s' =>\$md_dir,
		'html=s'     =>\$html_dir,
		'css=s'      =>\$css_dir,
		'pdf=s'      =>\$pdf_dir,
		'mdtohtml=s' =>\$mdtohtml ,
		'htmltopdf=s'=>\$htmltopdf,
		'pwd=s'      =>\$pwd,
		'TZ=s'       =>\$tz
	);

	my @md_path=glob $work_dir.'/'.$md_dir.'/*.md';
	my @css_path=glob $work_dir.'/'.$css_dir.'/*.css';
	
	trim_workdir_css_files($work_dir,\@css_path);

	system('cp '.$work_dir.'/base/* '.$work_dir.'/pdf/');

	foreach(@md_path){
		my $md_name=&basename($_);
		my $html_name=&ret_ext_change($md_name,'html');
		my $pdf_name=&ret_ext_change($md_name,'pdf');
		
		my @cmd=(&docker_cmd_mdtohtml($work_dir,$md_dir,$html_dir,$mdtohtml,$pwd,$md_name,$html_name,\@css_path) , &docker_cmd_htmltopdf($work_dir,$html_dir,$pdf_dir,$htmltopdf,$pwd,$html_name,$pdf_name,$tz));
		print Dumper @cmd;
		system(join('&&',@cmd));
	}
}

&main;
