" File: autoscroll.vim
" Author:LiuXiangqian (www.lvying.org)
" Version: 0.04
" Last Modify: May 6, 2005
" ChangeLog:
" Version 0.02:
"   1.add autoscroll in insert mode 
"   2.correct(or mistake) some grammar mistakes(or correct ones) in the documentation
"   3.separate the Installation part of documentation to Installation and
"     Configuration
" Version 0.03
"   1. some more bug of cursor position mistakes fixed
"   2. fix the bug when the cursor is at the end of a line, an <Enter> would make
"      a character down to the current line
" Version 0.04
"   1. fix the bug when the character at the end of the line is a multibyte character
"      in insert mode, an <Enter> would pull the last character to the next line.
" Installation:
" -------------
" 1.copy the autoscroll.vim script to  $HOME/.vim/plugin directory or where
"   the vim program can find the script at startup. Or you can put autoscroll.vim
"   some other place, and then use :so PATH_TO_AUTOSCROLL_SCRIPT/autoscroll.vim 
"   in $HOME/.vimrc to execute the script. Refer to ':help add-plugin', 
"   ':help add-global-plugin' and ':help runtimepath' for more details about
"   vim plugins. Refer to ':help so' for more details about read Ex commands from
"   a file.
" 2.Restart vim
" Configuration:
" -------------
" 1.Set topScrollNumber and bottomScrollNumber variable, if you do not
"   set these two variables explicitly, they would both get default value of 5.
"   TopScrollNumber is the amount of lines above your cursor lines when the
"   auto down scroll occurs in normal and insert mode. As you may dope out, 
"   bottomScrollNumber is the amount of lines down to your cursor line when the
"   auto up scroll occurs in normal and insert mode. You may set these 
"   two variables using let in you .vimrc
"   For example,
"             let topScrollNumber = 8
"             let bottomScrollNumber = 8
" 2.Set the updatetime variable. Refer to :help updatetime to see
"   what's the meaning of variable updatetime. You may set this variable using
"   let in your .vimrc. For example,
"             let updatetime = 100
"   this variable only affect the auto scroll behavior in normal mode.
"   Note: You should set this variable explicitly in your .vimrc.
" 3.Set the variable bottomRowNumberInsertMode. This variable would get 
"   default value of 5 if you don't set it explicitly. This variable is the 
"   amount of line below your current line when you press Enter to produce a
"   new line near the bottom of the screen, if there are not enough lines 
"   below current line to be displayed, coequal height of blank space would 
"   be displayed. You may set this variable using let in your .vimrc.
"   For example,
"             let bottomRowNumberInsertMode = 9
" 4.If you use <UP> and <DOWN> to scroll in insert mode, you need no changes
"   for the key binding, but if you bind some other keys to scroll in insert
"   mode, you have to change your key binding to let it auto scroll at the same 
"   time. For example, if you bind the key combine Ctrl+k and Ctrl+j to scroll 
"   up and down in insert mode, you should configure the key binding as below:
"           inoremap <C-K> <ESC>:call Check_Scroll()<CR>a<UP>
"           inoremap <C-J> <ESC>:call Check_Scroll()<CR>a<DOWN>
"   If you want to bind the key <UP> and <DOWN> to other operation in insert
"   mode, you have to comment the keymap definition of <UP> and <DOWN> below . 
" Usage:
" -----
"   Just enjoy the convenience of see the context of current line all the time.
" Known BUGS:
" ---------
" 1.If you set wrap display and the length of a line is larger than your set of 
"   textwidth, the cursor would jump back by force and you should quick enough to
"   move your cursor rushing across this line, So I suggest set updatetime to 
"   match your speed of moving the cusor, 100ms is a good choice in my opinion.
" 2.The auto scroll act based on lines separate by line break, not lines wraped
"   by vim(This may not be suppose to a bug)
" 3.If you place the cursor at the second column of one line, and then press <ENTER>, 
"   the cursor would jump to the beginning of the line and pull the first character to
"   next line also, this happens when you are in the insert mode. So you may want to 
"   bind the auto scroll version of <ENTER> to some other keys such as <C-CR>, Then you
"   should change the key binding of <CR> below to
"              inoremap <C-CR> <Esc>:call Check_Scroll_Insert()<CR>i<CR>
" IMPORTANT ATTENTION:
" --------------------
" 4.Sometimes, the cursor may be locked, (seems random so far to me, the reason 
"   remains unknown, but the probability is very very very small), and you can not
"   change the position of the cursor and the mode of VIM, if you are using GVIM,
"   you can still select  file -> save in the menu bar to save your unsaved files
"   since VIM isn't crack except for the lock.
"   Unfortunately, if you are using vim in console and there is no gui menu,
"   I haven't find a way to save my unsaved file,if you find one,please contact me
"   at smartLitchi@gmail.com. Appreciate all your help~~.Before you find one, carefully
"   enough to using this plugin in console vim.
" Acknowledgement:
" ---------------
"   This script is base on redhair's autoscroll.vim
"   (See x-4-6 in vim board of newsmth.net)
"   I should express my appreciate to redhair@smth
" TODO: 
"   I wouldn't add new function to this script except for bug fixes.
" Bug Report:
" ----------
"   Please send an E-mail to smartLitchi@gmail.com if you find an bug, or you
"   can send a personal message to truelvying@newsmth. Best wishes.
" License:
" -------
"   This plugin has the same license as vim.

" If you want to change the key bind <CR> in insert mode, please
" change the follow line. Refer to the Known BUGS part 3 for more details
inoremap <CR> <Esc>:call Check_Scroll_Insert()<CR>i<CR>

" If you want to change the key bind <UP> and <LEFT> in insert mode
" Please change the follow two lines
" Refer to the Configuration part 4 for more details.
inoremap <UP> <ESC>:call Check_Scroll()<CR>a<UP>
inoremap <DOWN> <ESC>:call Check_Scroll()<CR>a<DOWN>

if !exists('topScrollNumber')
  let topScrollNumber = 5 
endif
if !exists('bottomScrollNumber')
  let bottomScrollNumber = 5 
endif
if !exists('bottomRowNumberInsertMode')
  let bottomRowNumberInsertMode = 5 
endif

autocmd CursorHold * silent call Check_Scroll()

function! Check_Scroll()
  let topScrollNumber = g:topScrollNumber
  let bottomScrollNumber = g:bottomScrollNumber
  let cursorlno = winline() 
  let winht = winheight(winnr())

  if winht <= cursorlno + bottomScrollNumber - 1 && line(".") <= line("$") - bottomScrollNumber
    exec 'normal '.bottomScrollNumber.'gj'.bottomScrollNumber.'gk'
  endif

  if cursorlno <= topScrollNumber && line(".") > cursorlno
    exe 'normal '.topScrollNumber.'gk'.topScrollNumber.'gj'
  endif
endfunction

function! Check_Scroll_Insert()
  let s:bottomRowNumberInsertMode = g:bottomRowNumberInsertMode
  let s:cursorlno = winline() 
  let s:winht = winheight(winnr()) 
  if s:winht <= s:cursorlno + s:bottomRowNumberInsertMode - 1
    let s:scrollUp = s:winht/2 - s:bottomRowNumberInsertMode
    exec 'normal zb'
    exec 'normal '.s:scrollUp.'k'
    exec 'normal zz'
    exec 'normal '.s:scrollUp.'j'
  endif
  if col(".") == col("$") - 1
    exec 'normal a '
   endif 
   if col(".") == col("$") - 2 && char2nr(expand("<cword>")) > 41377 && char2nr(expand("<cword>")) < 65184 
     "判断最后一个字符是汉字,就往后增加一个空格,然后回车
    exec 'normal A  ' 
   endif
  if col(".") > 1
    exec 'normal l'
  endif
endfunction

"vim:sts=2:sw=2:ff=unix:textwidth=78
