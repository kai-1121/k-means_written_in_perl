my @file1=glob"2007shuffle/*";
my @file2=glob"2008shuffle/*";

my $i=0;
my $k=0;
my $file1_length=@file1; #本当は@file1だが実験用に変えている
my $file2_length=@file2; #本当は@file2だが実験用に変えている

my $read_file=0;
my $line;
my $all_kuten_count=0;
my %all_vector;
#my %all_vector_1;#file1のすべてのベクトル
#my %all_vector_2;#file2のすべてのベクトル

#my @split_words;
#my $word;
my %hindo;
my %all_joui_hyaku;#各文章ベクトルの上位百語の集まり
my %key_value;

my $num_class=100;
my $num_shori=0;

#idfを求めるための準備
for($i=0;$i<$file1_length;$i++){
	open($read_file, "<", "$file1[$i]") or die("Error");
	while($line= <$read_file>){
		#print "$line";
		my @split_words=split(/\t/,$line);
		
		if($line=~/^(\S+)\s+名詞/){
			$hindo{"$split_words[0]"}+=1;
		#print "$split_words[0]\n";
	}
	
		if($split_words[0]=~/。/){
			$all_kuten_count++;
			#print "$split_words[0],$all_kuten_count\n";
		}
	
	
	}
	
	# foreach $k (keys %hindo){
		# print "$k,$hindo{$k}\n";
	# }
	
	close($read_file);
}


for($i=0;$i<$file2_length;$i++){
	open($read_file, "<", "$file2[$i]") or die("Error");
	while($line= <$read_file>){
		#print "$line";
		my @split_words=split(/\t/,$line);
		
		if($line=~/^(\S+)\s+名詞/){
			$hindo{"$split_words[0]"}+=1;
		#print "$split_words[0]\n";
	}
	
		if($split_words[0]=~/。/){
			$all_kuten_count++;
			#print "$split_words[0],$all_kuten_count\n";
		}
	
	
	}
	
	# foreach $k (keys %hindo){
		# print "$k,$hindo{$k}\n";
	# }
	
	close($read_file);
}

print "処理1を終えました";

#tfを求めるための準備とｔｆ,idf,tf*idfの計算
for($i=0;$i<$file1_length;$i++){
	my $mini_kuten_count=0;#一文章中の句点の数
	my %mini_hindo;#一文章中のwordの数
	#my $num_word=0;#連想配列mini_hindoの長さ#num_wordいらないかも
	my $j=0;#作業用変数
	my %vector; #tf*idfの値（上位百語を文章ベクトルの成分する）#外部変数にするべきかも
	
	open($read_file, "<", "$file1[$i]") or die("Error");
	while($line= <$read_file>){
		#print "$line";
		my @split_words=split(/\t/,$line);
		
		if($line=~/^(\S+)\s+名詞/){
			$mini_hindo{"$split_words[0]"}+=1;#このif文の中をどうするか？
		#print "$split_words[0]\n";
	}
	
		if($split_words[0]=~/。/){
			$mini_kuten_count++;
			#print "$split_words[0],$mini_kuten_count\n";
		}
	
	
	}
	
	 # foreach $k (keys %mini_hindo){
		# #print "$k,$mini_hindo{$k}\n";
		# $num_word++;#num_wordいらないかも
	# }
	#print "\n\n$num_word\n\n";
	
	close($read_file);
	
	#この辺どうするか？
	
	foreach $k (keys %mini_hindo){
		#print "$mini_kuten_count,$all_kuten_count\n";
		if($mini_kuten_count>0&&$all_kuten_count>0){#0で割る可能性を排除
			$vector{"$k"}=(($mini_hindo{"$k"}/$mini_kuten_count)*(-log($hindo{"$k"}/$all_kuten_count)));
			#print "keisan";
		}
		#print "$k,$vector{$k}:\n";#$vector{"$k"}では何故かダメ？	
	}
	
	@keyList = sort {$vector{$b} <=> $vector{$a}} keys %vector;#降順に連想配列のインデックス（word）をsort
	
	foreach $k (@keyList){
		$j++;
		if($j>=100){
			#$vector{"$k"}=0;
			last;
		}
		$all_vector{"$i"}{"$k"}=$vector{"$k"};
		$all_joui_hyaku{"$k"}=$vector{"$k"};#$kを把握するだけで値は関係ない
		$key_value{"$i"}="$k";
		#print "$k,$vector{$k}\n";
	}
	#print "("$i"+"$file1_length")\n";
	#print "\n\n\n\n\n\n";
	
}

for($i=0;$i<$file2_length;$i++){
	my $mini_kuten_count=0;#一文章中の句点の数
	my %mini_hindo;#一文章中のwordの数
	#my $num_word=0;#連想配列mini_hindoの長さ#num_wordいらないかも
	my $j=0;#作業用変数
	my %vector; #tf*idfの値（上位百語を文章ベクトルの成分する）#外部変数にするべきかも
	my $x=$file1_length;#$all_vector用の作業用変数
	
	open($read_file, "<", "$file2[$i]") or die("Error");
	while($line= <$read_file>){
		#print "$line";
		my @split_words=split(/\t/,$line);
		
		if($line=~/^(\S+)\s+名詞/){
			$mini_hindo{"$split_words[0]"}+=1;#このif文の中をどうするか？
		#print "$split_words[0]\n";
	}
	
		if($split_words[0]=~/。/){
			$mini_kuten_count++;
			#print "$split_words[0],$mini_kuten_count\n";
		}
	
	
	}
	
	 # foreach $k (keys %mini_hindo){
		# #print "$k,$mini_hindo{$k}\n";
		# $num_word++;#num_wordいらないかも
	# }
	#print "\n\n$num_word\n\n";
	
	close($read_file);
	
	#この辺どうするか？
	
	foreach $k (keys %mini_hindo){
		#print "$mini_kuten_count,$all_kuten_count\n";
		if($mini_kuten_count>0&&$all_kuten_count>0){#0で割る可能性を排除
			$vector{"$k"}=(($mini_hindo{"$k"}/$mini_kuten_count)*(-log($hindo{"$k"}/$all_kuten_count)));
			#print "keisan";
		}
		#print "$k,$vector{$k}:\n";#$vector{"$k"}では何故かダメ？	
	}
	
	@keyList = sort {$vector{$b} <=> $vector{$a}} keys %vector;#降順に連想配列のインデックス（word）をsort
	
	foreach $k (@keyList){
		$j++;
		if($j>=100){
			#$vector{"$k"}=0;
			last;
		}
		$x=$file1_length+$i;#file2の作業用変数
		$all_vector{"$x"}{"$k"}=$vector{"$k"};#$iでなく$xであることに注意
		$all_joui_hyaku{"$k"}=$vector{"$k"};#$kを把握するだけで値は関係ない
		$key_value{"$x"}="$k";
		#print "$k,$vector{$k}\n";
	}
	#print "("$i"+"$file1_length")\n";
	#print "\n\n\n\n\n\n";
	
}

print "処理2を終えました";

#類似度関数をcosとしてクラスタリングを行う(tf*idfが角度として反映される)
#最初にランダムにクラスタを割り振る
my %center_of_gravity;#最初はランダム
my %class;
my %pre_class;
my $file_all_length=$file1_length+$file2_length;

# for($i=0;$i<$file_all_length;$i++){
	# #すべての次元を考慮する際、各文章ベクトルには出てこない次元も成分0で作る
	# foreach $k (keys %all_joui_hyaku){
		# #print "$k,$hindo{$k}\n";
		# if(exists $all_vector{$i}{$k}){#""なくてもいい？
			
		# }
		# else{
			# $all_vector{"$i"}{"$k"}=0;
		# }
		# #print "$i,$k,$all_vector{$i}{$k}";
		
	# }
	# #print "\n\n\n\n\n\n\n\n\n\n\n\n";
# }

#-----------------------------------------------------------------------------------

# for(my $x=0;$x<$num_class;$x++){
	# my $rand_i=int(rand(1)*$file_all_length);
	# #print "class:$x,center_of_gravity_vector:$rand_i\n";
	# foreach $k (keys %all_joui_hyaku){
		# if(exists $all_vector{"$rand_i"}{"$k"}){
			# $center_of_gravity{"$x"}{"$k"}=$all_vector{"$rand_i"}{"$k"};
		# }
	# }
# }

# #重心も上位百語にする必要ある？


# for($i=0;$i<$file_all_length;$i++){
	# my %ruiji;
	# my $all_vector_ookisa=0;
	# my $center_of_gravity_ookisa=0;
	# my $naiseki=0;
	# for(my $x=0;$x<$num_class;$x++){
		# $all_vector_ookisa=0;
		# $center_of_gravity_ookisa=0;
		# $naiseki=0;
		# foreach $k (keys %all_joui_hyaku){	
			# if(exists $all_vector{"$i"}{"$k"}&&exists $center_of_gravity{"$x"}{"$k"}){
				# $all_vector_ookisa=$all_vector_ookisa+($all_vector{"$i"}{"$k"}*$all_vector{"$i"}{"$k"});
				# $center_of_gravity_ookisa=$center_of_gravity_ookisa+($center_of_gravity{"$x"}{"$k"}*$center_of_gravity{"$x"}{"$k"});
				# $naiseki=$naiseki+($all_vector{"$i"}{"$k"}*$center_of_gravity{"$x"}{"$k"});
			# }
		# }
		# if($all_vector_ookisa>0&&$center_of_gravity_ookisa>0){
			# $ruiji{"$x"}=$naiseki/sqrt($all_vector_ookisa)/sqrt($center_of_gravity_ookisa);
		# }
	# }
	
	# @keyList = sort {$ruiji{$b} <=> $ruiji{$a}} keys %ruiji;
	
	# foreach $k (@keyList){
		
		# $class{"$i"}="$k";#$iはファイル番号、$kはクラス番号
		# $pre_class{"$i"}="$k";#$class{"$i"}を入れたということ
		# #print "$ruiji{$k}\n";
		# #print "$i,$class{$i}\n";
		# last;
	# }
	# #print "\n\n\n\n\n\n\n\n\n\n\n\n";
# }
#----------------------------------------------------------------------------

for($i=0;$i<$file_all_length;$i++){
	$class{"$i"}=($i % $num_class);
	$pre_class{"$i"}=($i % $num_class);
}


#----------------------------------------------------------------------------
		
print "処理3を終えました";

while(1){
	
	my $flag=0;
	#各クラスタの重心を計算
	my %num_vector;
	#連想配列の初期化
for(my $x=0;$x<$num_class;$x++){
	$num_vector{"$x"}=0;
}	

#重心初期化
for(my $x=0;$x<$num_class;$x++){
	foreach $k (keys %all_joui_hyaku){
		#ベクトルの全要素をクラスタリング#$iに""いらない？
		if(exists $center_of_gravity{"$x"}{"$k"}){
			$center_of_gravity{"$x"}{"$k"}=0;	
		}
	}
}	

#ベクトルをクラスごとに足していく
for($i=0;$i<$file_all_length;$i++){
	foreach $k (keys %all_joui_hyaku){
		#ベクトルの全要素をクラスタリング#$iに""いらない？
		if(exists $all_vector{"$i"}{"$k"}){
			
			$center_of_gravity{"$class{$i}"}{"$k"}=$center_of_gravity{"$class{$i}"}{"$k"}+$all_vector{"$i"}{"$k"};
		}
	}	
	#初期化しなくて大丈夫？#$iに""いらない？
	$num_vector{"$class{$i}"}++;#すべてが空白の文章は想定しない	
		
}	

for(my $x=0;$x<$num_class;$x++){
	foreach $k (keys %all_joui_hyaku){
		#ベクトルの数で割って重心をとる
		if($num_vector{"$x"}>0){#0で割る可能性を排除
			if(exists $center_of_gravity{"$x"}{"$k"}){
				$center_of_gravity{"$x"}{"$k"}=$center_of_gravity{"$x"}{"$k"}/$num_vector{"$x"};
			}
		}
		#print "juusinn,$x,$center_of_gravity{$x}{$k}\n"; 	
	}		
	#print "\n\n\n\n\n\n\n\n\n\n\n\n";
}

#重心と近いもので新しくクラスタ作る

my $idou=0;
for($i=0;$i<$file_all_length;$i++){
	
	my %ruiji;
	my $all_vector_ookisa=0;
	my $center_of_gravity_ookisa=0;
	my $naiseki=0;
	for(my $x=0;$x<$num_class;$x++){
		$all_vector_ookisa=0;
		$center_of_gravity_ookisa=0;
		$naiseki=0;
		foreach $k (keys %all_joui_hyaku){	
			if(exists $all_vector{"$i"}{"$k"}&&exists $center_of_gravity{"$x"}{"$k"}){
				$all_vector_ookisa=$all_vector_ookisa+($all_vector{"$i"}{"$k"}*$all_vector{"$i"}{"$k"});
				$center_of_gravity_ookisa=$center_of_gravity_ookisa+($center_of_gravity{"$x"}{"$k"}*$center_of_gravity{"$x"}{"$k"});
				$naiseki=$naiseki+($all_vector{"$i"}{"$k"}*$center_of_gravity{"$x"}{"$k"});
			}
			
		}
		if($all_vector_ookisa>0&&$center_of_gravity_ookisa>0){
			$ruiji{"$x"}=$naiseki/sqrt($all_vector_ookisa)/sqrt($center_of_gravity_ookisa);
		}
	}
	
	@keyList = sort {$ruiji{$b} <=> $ruiji{$a}} keys %ruiji;
	
	foreach $k (@keyList){
		
		$class{"$i"}="$k";#$iはファイル番号、$kはクラス番号
		if($class{"$i"}!=$pre_class{"$i"}){
			$flag=1;
			print "\n$num_shori:前クラス$pre_class{$i}、今クラス:::::$class{$i}\n";
			$idou++;
		}
		$pre_class{"$i"}="$k";#$class{"$i"}を入れたということ
		#print "$ruiji{$k}\n";
		#print "$i,$class{$i}\n";
		last;
	}
	#print "\n\n\n\n\n\n\n\n\n\n\n\n";
}

	$num_shori++;
	print "\n$num_shori:移動$idou\n";
	
	if($flag==0){
		last;
	}	
	
	
}	

for(my $x=0;$x<$num_class;$x++){
	open(my $file_write, ">", "out2_$x.txt") or die("Error");
	close ($file_write);	
}

for($i=0;$i<$file_all_length;$i++){
	for(my $x=0;$x<$num_class;$x++){
		if($class{"$i"}=="$x"){
			open(my $file_write, ">>", "out2_$x.txt") or die("Error");
			if($i<$file1_length){
				print $file_write "$file1[$i]\n";
			}else{
				my $x=$i-$file1_length;
				print $file_write "$file2[$x]\n";
			}
			close ($file_write);
		}	
	}
	
}	

for(my $x=0;$x<$num_class;$x++){
	open(my $file_write, ">", "gra_out2_$x.txt") or die("Error");
	close ($file_write);	
}

for($i=0;$i<$num_class;$i++){
	foreach $k (keys %all_joui_hyaku){
		if(exists $center_of_gravity{"$i"}{"$k"}){
			open(my $file_write, ">>", "gra_out2_$i.txt") or die("Error");
			print $file_write "$k:$center_of_gravity{$i}{$k}\n";
			close ($file_write);
		}
	}
}

for($i=0;$i<$file_all_length;$i++){
	print "$i,$class{$i}\n";
}



#print "処理を終えました:randの方";
