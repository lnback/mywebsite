#!/bin/sh
set -e

start_local_hugo_server(){
    hugo server -D
}

update_algolia(){
    hugo-algolia -s
    printf  "\033[0;32m已经更新到 algolia ！！！\033[0m\n"
}

pushMyBlog(){
    printf "\033[0;32mDeploying updates to GitHub "https://github.com/lnback"\033[0m\n"
    git pull
    git add .
    
    msg="change MyBlog site $(date)"

    if [ "$# -gt 1" ]; then
        msg="$2"
    fi
    git commit -m "$msg"

    git push origin master
}

pushBlogAndAlgolia(){
    printf "\033[0;32mDeploying updates to GitHub "https://github.com/lnback"\033[0m\n"

    hugo --theme=LoveIt --buildDrafts

    cd public
    git pull

    git add .

    msg="rebuilding site $(date)"

    if [ "$#" -gt 1 ]; then
        msg="$2"
    fi

    git commit -m "$msg"

    git push origin master

    cd ..

    update_algolia
}

case $1 in
    # 本地调试hugo
    1)
        start_local_hugo_server
    ;;
    # 推送blog到github
    2)
        pushMyBlog $*
    ;;
    # 推送public到github并更新algolia
    3)
        pushBlogAndAlgolia $*
    ;;
    # 更新algolia
    4)
        update_algolia
esac