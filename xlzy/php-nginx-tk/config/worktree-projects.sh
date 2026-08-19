#!/usr/bin/env bash
# Worktree 项目注册表。使用函数而非关联数组，兼容 macOS 自带 Bash 3.x。

project_repository() {
  case "$1" in
    affiliate-api) printf '%s\n' 'affiliate-api.tiktoksaas.com' ;;
    mcn-api) printf '%s\n' 'mcn-api.tiktoksaas.com' ;;
    cmc-api) printf '%s\n' 'cmc-api.tiktoksaas.com' ;;
    *) return 1 ;;
  esac
}

project_libraries() {
  case "$1" in
    affiliate-api) printf '%s\n' 'tkslib' ;;
    mcn-api) printf '%s\n' 'mcnlib tkslib' ;;
    cmc-api) printf '%s\n' 'cmclib tkslib' ;;
    *) return 1 ;;
  esac
}

library_env() {
  case "$1" in
    tkslib) printf '%s\n' 'TKS_LIB_PATH' ;;
    mcnlib) printf '%s\n' 'MCN_LIB_PATH' ;;
    cmclib) printf '%s\n' 'CMC_LIB_PATH' ;;
    *) return 1 ;;
  esac
}

library_fallback() {
  case "$1" in
    tkslib) printf '%s\n' '/www/tkslib' ;;
    mcnlib) printf '%s\n' '/www/mcnlib' ;;
    cmclib) printf '%s\n' '/www/cmclib' ;;
    *) return 1 ;;
  esac
}
