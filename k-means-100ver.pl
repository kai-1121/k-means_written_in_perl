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

my $num_class=100;
my $num_shori=0;
my $vector_d=100;#考えるベクトルの次元数

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

#-----------------------------------------------
#ここからb.plと分岐

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
		$all_vector{"$i"}{"$j"}=$vector{"$k"};
		$j++;
		if($j>=100){
			last;
		}
		
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
		$x=$file1_length+$i;#file2の作業用変数
		$all_vector{"$x"}{"$j"}=$vector{"$k"};
		$j++;
		if($j>=100){
			last;
		}
		#print "$k,$vector{$k}\n";
	}
	#print "("$i"+"$file1_length")\n";
	#print "\n\n\n\n\n\n";
	
}

#類似度関数をcosとしてクラスタリングを行う(tf*idfが角度として反映される)
#最初にランダムにクラスタを割り振る
my %center_of_gravity;#最初はランダム
my %class;
my %pre_class;
my $file_all_length=$file1_length+$file2_length;

#0から１の範囲で,１００の重心のうちの一つの100次元ベクトルの一要素をとる
# for($i=0;$i<$vector_d;$i++){
	# my $x=0;#作業用変数$xは上で使ってるけど多分使って大丈夫	
		# for($x=0;$x<$num_class;$x++){
			# $center_of_gravity{"$x"}{"$i"}=rand(1);
		# }	
# }

# #文章ベクトルのうちランダムに$num_class個を各々重心ベクトルとする
# for(my $x=0;$x<$num_class;$x++){
	# my $rand_i=int(rand(1)*$file_all_length);
	# #print "class:$x,center_of_gravity_vector:$rand_i\n";
	# for(my $y=0;$y<$vector_d;$y++){
		# $center_of_gravity{"$x"}{"$y"}=$all_vector{"$rand_i"}{"$y"};
		# if($x==0||$x==1){
			# #print "$rand_i,$all_vector{$rand_i}{$y}\n";
		# }
	# }
# }	


# #print "\n\n\n\n\n\n\n\n\n\n\n\n";
# for($i=0;$i<$file_all_length;$i++){
	# my %ruiji;
	# my $all_vector_ookisa=0;
	# my $center_of_gravity_ookisa=0;
	# my $naiseki=0;
	# #類似度関数ユークリッド距離
	# my $kyori=0;
	# for(my $x=0;$x<$num_class;$x++){
		# $all_vector_ookisa=0;
		# $center_of_gravity_ookisa=0;
		# $naiseki=0;
		# $kyori=0;
		# for(my $y=0;$y<$vector_d;$y++){	
			# #類似度関数cos
			# $all_vector_ookisa=$all_vector_ookisa+($all_vector{"$i"}{"$y"}*$all_vector{"$i"}{"$y"});
			# $center_of_gravity_ookisa=$center_of_gravity_ookisa+($center_of_gravity{"$x"}{"$y"}*$center_of_gravity{"$x"}{"$y"});
			# $naiseki=$naiseki+($all_vector{"$i"}{"$y"}*$center_of_gravity{"$x"}{"$y"});
			# #類似度関数ユークリッド距離
			# #$kyori=$kyori+($all_vector{"$i"}{"$y"}-$center_of_gravity{"$x"}{"$y"})*($all_vector{"$i"}{"$y"}-$center_of_gravity{"$x"}{"$y"});
		# }
		# #類似度関数cos
		# if($all_vector_ookisa>0&&$center_of_gravity_ookisa>0){
			# $ruiji{"$x"}=$naiseki/sqrt($all_vector_ookisa)/sqrt($center_of_gravity_ookisa);
		# }
		# #類似度関数ユークリッド距離
		# #$ruiji{"$x"}=sqrt($kyori);
	# }
	
	# # if($i==0){
		# # for(my $x=0;$x<$num_class;$x++){
			# # print "$x,$ruiji{$x}\n";
		# # }	
		# # print "\n\n\n\n\n\n\n\n\n\n\n\n";
	# # }
	
	# #類似度関数cos
	# @keyList = sort {$ruiji{$b} <=> $ruiji{$a}} keys %ruiji;
	# #類似度関数ユークリッド距離
	# #@keyList = sort {$ruiji{$a} <=> $ruiji{$b}} keys %ruiji;
	
	# # if($i==0){
		# # for(my $x=0;$x<$num_class;$x++){
			# # print "$x,$ruiji{$x}\n";
		# # }	
		# # print "\n\n\n\n\n\n\n\n\n\n\n\n";
	# # }
	
	# foreach $k (@keyList){
		# #print "$i,$k,$ruiji{$k}\n";
		# $class{"$i"}="$k";#$iはファイル番号、$kはクラス番号
		# $pre_class{"$i"}="$k";#$class{"$i"}を入れたということ
		# #print "$ruiji{$k}\n";
		# #print "$i,$class{$i}\n";
		# last;
	# }
	# #print "\n\n\n\n\n\n\n\n\n\n\n\n";
# }

#print "\n\n\n\n\n\n\n\n\n\n\n\n";

# for($i=0;$i<$file_all_length;$i++){
	# print "$i,$class{$i}\n";
# }
		
for($i=0;$i<$file_all_length;$i++){
	$class{"$i"}=($i % $num_class);
	$pre_class{"$i"}=($i % $num_class);
}

while(1){
	
	my $flag=0;
	#各クラスタの重心を計算
	my %num_vector;
	#全要素が0より上だと仮定している
	#my $num_vector=100;#重心をとる時に各要素を割る値、基本は100次元なので今回は１００#次元数じゃなくてベクトルの数では？
	
	#連想配列の初期化
for(my $x=0;$x<$num_class;$x++){
	$num_vector{"$x"}=0;
}	

#重心初期化
for(my $x=0;$x<$num_class;$x++){
	for(my $y=0;$y<$vector_d;$y++){
		#ベクトルの全要素をクラスタリング#$iに""いらない？
		$center_of_gravity{"$x"}{"$y"}=0;	
		}
		$num_vector{"$x"}=0;
}	

#ベクトルをクラスごとに足していく
for($i=0;$i<$file_all_length;$i++){
	for(my $y=0;$y<$vector_d;$y++){
		#ベクトルの全要素をクラスタリング#$iに""いらない？
		$center_of_gravity{"$class{$i}"}{"$y"}=$center_of_gravity{"$class{$i}"}{"$y"}+$all_vector{"$i"}{"$y"};
	}	
	$num_vector{"$class{$i}"}++;
	#初期化しなくて大丈夫？#$iに""いらない？
	#$num_vector{"$class{$i}"}++;#すべてが空白の文章は想定しない	
		
}	

# for(my $x=0;$x<$num_class;$x++){
	# for(my $y=0;$y<$vector_d;$y++){
		# if($x<10){
			# print "juusinn,$x,$center_of_gravity{$x}{$y}\n"; 
		# }
	# }	
	# if($x<10){	
		# print "\n\n\n\n\n\n\n\n\n\n\n\n";
	# }
# }

for(my $x=0;$x<$num_class;$x++){
	for(my $y=0;$y<$vector_d;$y++){
		#ベクトルの数で割って重心をとる
		if($num_vector{"$x"}>0){#0で割る可能性を排除
			$center_of_gravity{"$x"}{"$y"}=$center_of_gravity{"$x"}{"$y"}/$num_vector{"$x"};
		}
		# if($x<10){
			# print "juusinn,$x,$center_of_gravity{$x}{$y}\n"; 
		# }	
	}	
	# if($x<10){	
		# print "\n\n\n\n\n\n\n\n\n\n\n\n";
	# }
}

#重心と近いもので新しくクラスタ作る

for($i=0;$i<$file_all_length;$i++){
	my %ruiji;
	my $all_vector_ookisa=0;
	my $center_of_gravity_ookisa=0;
	my $naiseki=0;
	#類似度関数ユークリッド距離
	my $kyori=0;
	for(my $x=0;$x<$num_class;$x++){
		$all_vector_ookisa=0;
		$center_of_gravity_ookisa=0;
		$naiseki=0;
		$kyori=0;
		for(my $y=0;$y<$vector_d;$y++){	
			#類似度関数cos
			$all_vector_ookisa=$all_vector_ookisa+($all_vector{"$i"}{"$y"}*$all_vector{"$i"}{"$y"});
			$center_of_gravity_ookisa=$center_of_gravity_ookisa+($center_of_gravity{"$x"}{"$y"}*$center_of_gravity{"$x"}{"$y"});
			$naiseki=$naiseki+($all_vector{"$i"}{"$y"}*$center_of_gravity{"$x"}{"$y"});
			#類似度関数ユークリッド距離
			#$kyori=$kyori+($all_vector{"$i"}{"$y"}-$center_of_gravity{"$x"}{"$y"})*($all_vector{"$i"}{"$y"}-$center_of_gravity{"$x"}{"$y"});
		}
		#類似度関数cos
		if($all_vector_ookisa>0&&$center_of_gravity_ookisa>0){
			$ruiji{"$x"}=$naiseki/sqrt($all_vector_ookisa)/sqrt($center_of_gravity_ookisa);
		}
		#類似度関数ユークリッド距離
		#$ruiji{"$x"}=sqrt($kyori);
	}
	
	#類似度関数cos
	@keyList = sort {$ruiji{$b} <=> $ruiji{$a}} keys %ruiji;
	#類似度関数ユークリッド距離
	#@keyList = sort {$ruiji{$a} <=> $ruiji{$b}} keys %ruiji;
	
	# if($i==0){
		# foreach $k (@keyList){
			# print "$k,$ruiji{$k}\n";
		# }	
		# print "\n\n\n\n\n\n\n\n\n\n\n\n";
	# }
	
	# my $xxx=0;
	# foreach $k (@keyList){
		# print "$i,$k,$ruiji{$k}\n";
		# $xxx++;
		# if($xxx>10){
			# last;
		# }
	# }
	
	foreach $k (@keyList){
		#print "$i,$k,$ruiji{$k}\n";
		$class{"$i"}="$k";#$iはファイル番号、$kはクラス番号
		if($class{"$i"}!=$pre_class{"$i"}){
			$flag=1;
		}
		$pre_class{"$i"}="$k";#$class{"$i"}を入れたということ
		#print "$ruiji{$k}\n";
		#print "$i,$class{$i}\n";
		last;
	}
	#print "\n\n\n\n\n\n\n\n\n\n\n\n";
}

	$num_shori++;
	print "$num_shori\n";
	
	if($flag==0){
		last;
	}	
	
	
}	

for(my $x=0;$x<$num_class;$x++){
	open(my $file_write, ">", "100_out_$x.txt") or die("Error");
	close ($file_write);	
}

for($i=0;$i<$file_all_length;$i++){
	for(my $x=0;$x<$num_class;$x++){
		if($class{"$i"}=="$x"){
			open(my $file_write, ">>", "100_out_$x.txt") or die("Error");
			print $file_write "$file1[$i]\n";
			close ($file_write);
		}	
	}
	
}	

print "\n\n\n\n\n\n\n\n\n\n\n\n";
for($i=0;$i<$file_all_length;$i++){
	print "$i,$class{$i}\n";
 }

print "処理を終えました";
