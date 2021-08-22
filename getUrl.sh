#! /bin/bash

function sortByDate() {
    # 将入参转换成数组，默认以空格作为分隔符
    FILE_PATH_ARRAY=( $(echo $1) );

    # timeOrder -> file array的映射，具有相同timeOrder的文件被汇聚在了一起
    declare -A FILE_MAP;

    # timeOrder 数组
    TIME_ORDER_ARRAY="";
    for FILE_PATH in ${FILE_PATH_ARRAY[*]}
    do
        TEMP_FILE_PATH=${FILE_PATH#*/public/}
        YEAR_MON_DAY=( $(echo ${TEMP_FILE_PATH} | awk 'BEGIN{FS="/"} {print $1 " " $2 " " $3}') );
        TIME_ORDER=$(( 10#${YEAR_MON_DAY[0]} * 10000 + 10#${YEAR_MON_DAY[1]} * 100 + 10#${YEAR_MON_DAY[2]} ));
        
        if [ -n "${TIME_ORDER_ARRAY}" ]
        then
            TIME_ORDER_ARRAY=${TIME_ORDER_ARRAY}"\n"${TIME_ORDER};
        else
            TIME_ORDER_ARRAY=${TIME_ORDER};
        fi

        if [ -n "${FILE_MAP["${TIME_ORDER}"]}" ]
        then
            FILE_MAP["${TIME_ORDER}"]=${FILE_MAP["${TIME_ORDER}"]}" "${FILE_PATH};
        else
            FILE_MAP["${TIME_ORDER}"]=${FILE_PATH};
        fi

    done

    # 排序，将乱序的 TIME_ORDER_ARRAY 转换成 有序的 SORTED_UNIQUE_TIME_ORDER_ARRAY
    SORTED_UNIQUE_TIME_ORDER_ARRAY="";
    while read LINE
    do
        if [ -n "${SORTED_UNIQUE_TIME_ORDER_ARRAY}" ]
        then
            SORTED_UNIQUE_TIME_ORDER_ARRAY=${SORTED_UNIQUE_TIME_ORDER_ARRAY}" "${LINE};
        else
            SORTED_UNIQUE_TIME_ORDER_ARRAY=${LINE};
        fi
    # 此处语法为：进程替换
    done < <(echo -e ${TIME_ORDER_ARRAY} | sort -nu) 

    # 遍历SORTED_UNIQUE_TIME_ORDER_ARRAY 中的 timeOrder，从FILE_MAP中取出对应于 timeOrder 的文件列表
    i=0;
    for TIME_ORDER in ${SORTED_UNIQUE_TIME_ORDER_ARRAY[*]}
    do
        for FILE_PATH in ${FILE_MAP["${TIME_ORDER}"]}
        do
            FILE_PATH_ARRAY[${i}]=${FILE_PATH};
            ((i++))
        done
    done

    echo "${FILE_PATH_ARRAY[*]}"
}

DIR=$1;

# 除去 从右往左 第一个/以及右边所有字符。例如a/b/c/ -> a/b/c
DIR=${DIR%/*};

if [ ! -d ${DIR}/public ]
then
    echo "Wrong dir: $DIR";
    exit 1;
fi

# 博客地址前缀
BLOG_URL_PREFIX=https://liuyehcf.github.io/;

# 年份
YEARS=(2017 2018 2019);

# 查找所有index.html文件，一个文件对应一篇博文

INDEX_FILES="";

for YEAR in ${YEARS[*]}
do
    INDEX_FILES="${INDEX_FILES} $(find ${DIR}/public/$YEAR -name 'index.html')";
done

# 文章的总数
COUNT=$(echo ${INDEX_FILES} | awk '{print NF}');

# 每一个文章的路径
FILE_PATH_ARRAY=( $(echo ${INDEX_FILES}) );

# 按照日期排序
FILE_PATH_ARRAY=( $(sortByDate "${FILE_PATH_ARRAY[*]}") )

rm -f ${DIR}/url.list;

for FILE_PATH in ${FILE_PATH_ARRAY[*]}
do
    # 此时FILE_PATH形如:`public/2018/01/12/Mac-个性化配置/index.html`

    # 除去public/
    FILE_PATH=${FILE_PATH#*public/};

    # 除去最右边的/index.xml
    FILE_PATH=${FILE_PATH%/index.html}"/";

    # 合成最终的访问url
    URL=${BLOG_URL_PREFIX}${FILE_PATH};

    echo $URL >> ${DIR}/url.list;
done
