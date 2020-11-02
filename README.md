Red Panda Dev C++ （小熊猫Dev-C++，old name Dev-C++ 2000） is a fork of Orwell Dev-C++ (https://sourceforge.net/p/orwelldevcpp).

Orwell Dev-C++ has stopped update since 2016, So I forked it. 

It's intended to be used for eductional purposes.

Website: https://royqh.net/devcpp-en/

中文网站在这里 https://royqh.net/devcpp/

HighLights of News:
 * Greatly improved "Auto Code Completion":
   * Fixed header parsing error. Can correctly show type hints for std::string, for example.
   * Auto code suggestion while typing.
   * In editor option dialog, user can choose to use Alt+/ instead of Ctrl+Space to call Code Completion Action. (In chinese systems, Ctrl-Space is used for switching input methods). And if there is only one code suggestion candidate, it is auto used and the suggestion form will not be displayed. This will speed the input.
   * Suggestion form can capture TAB keypress event now.
 * Greatly improved Debugger:
   * breakpoints on condition
   * Redesigned Debugger panel, add Call Stack / Breakpoints sheet
   * Debug Output window can hide all annotions of the output. This makes it much better to look, and we can use it just like using a gdb console.
   * If no breakpoint is set, the debugged program will pause at the entrance of main().
 * Greatly improved ClassBrowser:
   * Correctly show #define/typedef/enum/class/struct/global var/function infos
   * sort by type/ alphabetically
   * show/hide inherited members
   * correctly differentiate static class members / class members;
 * Greatly improved Code Parser, faster and less error;
 * Greatly improved "Auto symbol completion" function. Autoskip matched )/}/]/"/', never need to delete it or skip it manually. This makes code input much fluent.
 * Fix auto-indent; When } is inputted, its line will intend to the same as the matching {.
 * GDB 9.2 and GCC 9.2
 * User can open/edit/save/compile UTF-8 encoding files.
 * rename symbol
 * -Wall -Wextra -Werror is setted by default in the Debug profile, to help beginners learn good coding habits.
 * redirect STDIN to a data file while running or debuging ( to easy debug / need a patched gdb ) 
 * xege(graphics.h) and libturtle integration
 
And lots of fixes and changes, see News.txt  
