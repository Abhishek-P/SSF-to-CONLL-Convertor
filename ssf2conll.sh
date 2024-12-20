#!/usr/bin/env bash
# Set python version to 2.7
pyenv shell 2.7
echo `python --version`
# TODO abhip: Changes to make it runnable from an external project as submodule
if [[ $# -eq 4 ]]; then
	echo -n "" > $2
	echo -n "" > $3
else
	echo "Please specify the required valid arguments as :: <input file|directory> <output file> <log file> <annotation type>"
	exit 1
fi

INPUT=$1 
OUTPUT=$2
LOGFILE=$3
annotationType=$4

if [[ -d $INPUT ]]; then
	for input in $(find $INPUT -name '*' ); 
	do
		if [[ -f $input ]];then
			echo -n "" > head_vib.temp
			echo $input >> $LOGFILE
			if [[ $annotationType == "inter" ]];then
			python ssf2conll/run_dependencies.py $input head_vib.temp $LOGFILE
			python ssf2conll/ssfToConll.py --input-file head_vib.temp --output-file $OUTPUT --log-file \
				$LOGFILE --annotation $annotationType
			mv $OUTPUT $input
			elif [[ $annotationType == "intra" ]]; then
			python ssf2conll/ssfToConll.py --input-file $input --output-file $OUTPUT --log-file \
				$LOGFILE --annotation $annotationType
			mv $OUTPUT $input
			else
				echo 'Type of annotation not defined. Exiting now!'
				exit
			fi
		fi
	done
else
	if [[ $annotationType == "inter" ]];then
		python ssf2conll/run_dependencies.py $INPUT head_vib.temp $LOGFILE
		python ssf2conll/ssfToConll.py --input-file head_vib.temp --output-file $OUTPUT --log-file \
			$LOGFILE --annotation $annotationType
	elif [[ $annotationType == "intra" ]]; then
		python ssf2conll/ssfToConll.py --input-file $INPUT --output-file $OUTPUT --log-file \
			$LOGFILE --annotation $annotationType
	else
		echo 'Type of annotation not defined. Exiting now!'
			exit
	fi
fi

if [[ -f head_vib.temp ]];then
	rm head_vib.temp
fi
