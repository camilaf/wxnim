
import "../wx", "../stc"

{.experimental.}

proc createFrame(): ptr WxFrame
proc createText(): ptr WxStyledTextCtrl

let f = createFrame()
let styledText = createText()

proc handleButtonClick(e: var WxCommandEvent) {.cdecl.} =
  f.setStatusText("Quit called!")
    
proc onMarginClick(e: var WxStyledTextEvent) {.cdecl.} =
  if (e.getMargin() == 1):
    let lineClick = styledText.lineFromPosition(e.getPosition())
    let levelClick = styledText.getFoldLevel(lineClick)

    if ((levelClick and wxSTC_FOLDLEVELHEADERFLAG) > 0):
      styledText.toggleFold(lineClick)

proc createFrame(): ptr WxFrame =
  result = cnew constructWxFrame(nil, wxID_ANY, "Hello World",
                                 constructWxPoint(50, 50),
                                 constructWxSize(450, 340))

  let newId = newControlId()
  let openId = newControlId()
  let saveId = newControlId()
  let menuOptions = cnew constructwxMenu()
  menuOptions.append(newId, "&New")
  menuOptions.append(openId, "&Open")
  # Load the contents of filename into the editor:
  # bool wxStyledTextCtrl::LoadFile	(	const wxString & 	filename	)	
  menuOptions.append(saveId, "&Save")
  # Write the contents of the editor to filename:
  # bool wxStyledTextCtrl::SaveFile	(	const wxString & 	filename	)	

  let menuHelp = cnew constructWxMenu()
  menuHelp.append(wxID_ABOUT)
  let menuBar = cnew constructWxMenuBar()
  menuBar.append(menuOptions, "&File")
  menuBar.append(menuHelp, "&Help")
  result.setMenuBar(menuBar)
  menuBar.`bind`(wxEVT_MENU, handleButtonClick, wxID_ABOUT)
  
  menuBar.`bind`(wxEVT_MENU, handleButtonClick, cast[WxStandardID](newId))

  result.createStatusBar()
  result.setStatusText("Welcome to wxWidgets!")


proc createText(): ptr WxStyledTextCtrl =
  let text = cnew constructWxStyledTextCtrl(f, wxID_ANY)
  text.styleClearAll()
  text.setLexer(wxSTC_LEX_CPP)
  text.setMarginWidth(0, 50)
  text.styleSetForeground(wxSTC_STYLE_LINENUMBER, constructWxColour(75, 75, 75))
  text.styleSetBackground(wxSTC_STYLE_LINENUMBER, constructWxColour(220, 220, 220))
  text.setMarginType(0, wxSTC_MARGIN_NUMBER)

  # CODE FOLDING START

  text.setMarginType(1, wxSTC_MARGIN_SYMBOL)
  text.setMarginWidth(1, 15)
  text.setMarginMask(1, cast[cint] (wxSTC_MASK_FOLDERS))
  text.styleSetBackground(1, constructWxColour(200, 200, 200))
  text.setMarginSensitive(1, true)

  text.setProperty("fold", "1")
  text.setProperty("fold.comment", "1")
  text.setProperty("fold.compact", "1")
  
  let grey = constructwxColour(100, 100, 100)
  text.markerDefine(wxSTC_MARKNUM_FOLDER, wxSTC_MARK_ARROW)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDER, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDER, grey)

  text.markerDefine(wxSTC_MARKNUM_FOLDEROPEN, wxSTC_MARK_ARROWDOWN)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDEROPEN, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDEROPEN, grey)

  text.markerDefine(wxSTC_MARKNUM_FOLDERSUB, wxSTC_MARK_EMPTY)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDERSUB, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDERSUB, grey)

  text.markerDefine(wxSTC_MARKNUM_FOLDEREND, wxSTC_MARK_ARROW)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDEREND, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDEREND, constructwxColour(255, 255, 255))

  text.markerDefine(wxSTC_MARKNUM_FOLDEROPENMID, wxSTC_MARK_ARROWDOWN)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDEROPENMID, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDEROPENMID, constructwxColour(255, 255, 255))

  text.markerDefine(wxSTC_MARKNUM_FOLDERMIDTAIL, wxSTC_MARK_EMPTY)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDERMIDTAIL, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDERMIDTAIL, grey)

  text.markerDefine(wxSTC_MARKNUM_FOLDERTAIL, wxSTC_MARK_EMPTY)
  text.markerSetForeground(wxSTC_MARKNUM_FOLDERTAIL, grey)
  text.markerSetBackground(wxSTC_MARKNUM_FOLDERTAIL, grey)

  # CODE FOLDING END

  text.setWrapMode(wxSTC_WRAP_WORD)
  var myFont = constructwxFont(constructwxSize(13, 13), wxFONTFAMILY_TELETYPE, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL)
  for n in 0..24:
    text.styleSetFont(cast[cint] (n), myFont);

  text.setText("// Some example\n#define MAX 0\n\n/** @brief The entry point */\nint main(int argc, char *argv[])\n{\n    for (int n=0; n<MAX; n++)\n    {\n        printf(\"Hello World %i\\n\", n);\n    }\n    return 0;\n}\n")

  text.styleSetForeground(wxSTC_C_STRING, constructWxColour(150, 0, 0))
  text.styleSetForeground(wxSTC_C_PREPROCESSOR, constructWxColour(165, 105, 0))
  text.styleSetForeground(wxSTC_C_IDENTIFIER, constructWxColour(40, 0, 60))
  text.styleSetForeground(wxSTC_C_NUMBER, constructWxColour(0, 150, 0))
  text.styleSetForeground(wxSTC_C_CHARACTER, constructWxColour(150, 0, 0))  
  text.styleSetForeground(wxSTC_C_WORD, constructWxColour(0, 0, 150))
  text.styleSetForeground(wxSTC_C_WORD2, constructWxColour(0, 150, 0))
  text.styleSetForeground(wxSTC_C_COMMENT, constructWxColour(150, 150, 150))
  text.styleSetForeground(wxSTC_C_COMMENTLINE, constructWxColour(150, 150, 150))
  text.styleSetForeground(wxSTC_C_COMMENTDOC, constructWxColour(150, 150, 150))
  text.styleSetForeground(wxSTC_C_COMMENTDOCKEYWORD, constructWxColour(0, 0, 200))
  text.styleSetForeground(wxSTC_C_COMMENTDOCKEYWORDERROR, constructWxColour(0, 0, 200))

  text.styleSetBold(wxSTC_C_WORD, true)
  text.styleSetBold(wxSTC_C_WORD2, true)
  text.styleSetBold(wxSTC_C_COMMENTDOCKEYWORD, true)

  text.setKeyWords(0, "return for while break continue")
  text.setKeyWords(1, "const int float void char double")

  # Ejemplo para breakpoint
  text.setMarginType(2, wxSTC_MARGIN_SYMBOL)
  text.setMarginWidth(2, 15)
  text.setMarginMask(2, 1 shl 5)
  text.setMarginSensitive(2, true)

  text.markerDefine(5, wxSTC_MARK_CIRCLE)
  text.markerSetBackground(5, constructWxColour(255, 0, 0))
  text.markerSetForeground(5, constructWxColour(255, 0, 0)) 
  discard text.markerAdd(6, 5) 

  let sizer = cnew constructWxBoxSizer(wxVERTICAL)
  sizer.add(text, 1, wxEXPAND.cint)
  f.setSizer(sizer)

  text.`bind`(wxEVT_STC_MARGINCLICK, onMarginClick)
  return text


f.centre()
f.show(true)


runMainLoop()
