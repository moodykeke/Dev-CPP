{
    This file is part of Dev-C++
    Copyright (c) 2004 Bloodshed Software

    Dev-C++ is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Dev-C++ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dev-C++; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit LangFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus, FileCtrl, SynEdit, ToolWin, ComCtrls;

type
  TLangForm = class(TForm)
    OkBtn: TBitBtn;
    LangPanel: TPanel;
    lbLanguages: TListBox;
    grpLanguages: TGroupBox;
    lblLangInfo: TLabel;
    grpThemes: TGroupBox;
    cmbIcons: TComboBox;
    FinishPanel: TPanel;
    Finish2: TLabel;
    Finish3: TLabel;
    cmbColors: TComboBox;
    lblIcons: TLabel;
    lblColor: TLabel;
    Finish1: TLabel;
    synExample: TSynEdit;
    EditPanel: TPanel;
    lblEditInfo: TLabel;
    lblFont: TLabel;
    cmbFont: TComboBox;
    tbExample: TToolBar;
    NewFileBtn: TToolButton;
    OpenBtn: TToolButton;
    SaveUnitBtn: TToolButton;
    SaveAllBtn: TToolButton;
    CloseBtn: TToolButton;
    PrintBtn: TToolButton;
    UndoBtn: TToolButton;
    RedoBtn: TToolButton;
    FindBtn: TToolButton;
    ReplaceBtn: TToolButton;
    FindNextBtn: TToolButton;
    GotoLineBtn: TToolButton;
    CompileBtn: TToolButton;
    RunBtn: TToolButton;
    CompileAndRunBtn: TToolButton;
    RebuildAllBtn: TToolButton;
    DebugBtn: TToolButton;
    ProfileBtn: TToolButton;
    ProfilingInforBtn: TToolButton;
    Panel1: TPanel;
    procedure OkBtnClick(Sender: TObject);
    procedure ColorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FontChange(Sender: TObject);
    procedure cmbIconsChange(Sender: TObject);
    procedure cmbFontDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure HandleLangPanel;
    procedure HandleEditPanel;
    procedure UpdateLangList(List: TStrings);
    procedure LoadText;
  end;

implementation

uses
  Registry,MultiLangSupport, DataFrm, devcfg, utils, main, version, ImageTheme, SynEditTypes;

{$R *.dfm}

procedure TLangForm.LoadText;
begin
  grpThemes.Caption := Lang[ID_LANGFORM_SELECTTHEME];
  lblFont.Caption := Lang[ID_LANGFORM_FONT];
  lblColor.Caption := Lang[ID_LANGFORM_COLOR];
  lblIcons.Caption := Lang[ID_LANGFORM_ICONS];
  lblEditInfo.Caption := Lang[ID_LANGFORM_THEMCHANGEHINT];
  Finish1.Caption := Lang[ID_LANGFORM_FINISH1];
  Finish2.Caption := Lang[ID_LANGFORM_FINISH2];
  Finish3.Caption := Lang[ID_LANGFORM_FINISH3];
  OkBtn.Caption := Lang[ID_LANGFORM_NEXT];
end;

procedure TLangForm.UpdateLangList(List: TStrings);
var
  I, sel: integer;
  favorLang: ansistring;
begin
  lbLanguages.Items.BeginUpdate;
  try
    lbLanguages.Clear;
    favorLang:=GetLanguageFileName();
    for I := 0 to List.Count - 1 do begin
      sel := lbLanguages.Items.Add(List.ValueFromIndex[I]);
      if EndsText(favorLang, lbLanguages.Items[sel]) then
        lbLanguages.Selected[sel] := True;
    end;
  finally
    lbLanguages.Items.EndUpdate;
  end;
end;

procedure TLangForm.HandleLangPanel;
var
  SelectedLang: AnsiString;
begin
  OkBtn.Tag := 1;
  LangPanel.Visible := false;

  // Update translation
  if lbLanguages.ItemIndex <> -1 then begin
    SelectedLang := Lang.Langs.Names[lbLanguages.ItemIndex];
    Lang.Open(SelectedLang);
    devData.Language := Lang.FileFromDescription(SelectedLang);
  end else begin
    Lang.Open('English.lng');
  end;
  LoadText;

  EditPanel.Visible := true;
end;

procedure TLangForm.HandleEditPanel;
begin
  OkBtn.Tag := 2;
  OkBtn.Kind := bkOK;
  OkBtn.ModalResult := mrOK;
  EditPanel.Visible := false;
  FinishPanel.Visible := true;
  devData.ThemeChange := true;
  devData.Theme := cmbIcons.Items[cmbIcons.ItemIndex];

end;

procedure TLangForm.OkBtnClick(Sender: TObject);
var
  lReg: TRegistry;
begin
  case OkBtn.Tag of
    0: HandleLangPanel;
    1: HandleEditPanel;
    2: begin
        // open registry, set root and key
        lReg := TRegistry.Create;
        try
          lReg.RootKey := HKEY_CURRENT_USER;
          lReg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', True);
          // write last Left, Top, Width and Height
          lReg.WriteString(Application.ExeName, '~ HIGHDPIAWARE');
          // close all
          lReg.CloseKey;
        finally
          lReg.Free;
        end;
      end;
  end;

end;

procedure TLangForm.FormShow(Sender: TObject);
var
  FontIndex: Integer;
begin
  // Set interface font
  Font.Name := devData.InterfaceFont;
  Font.Size := devData.InterfaceFontSize;

  // Set demo caret
  synExample.CaretXY := BufferCoord(11, 5);

  // Interface themes
  devImageThemes.GetThemeTitles(cmbIcons.Items);
  cmbIcons.ItemIndex := 0; // new look

  // Editor colors
  cmbColors.ItemIndex := 11; // Vs Code
  dmMain.InitHighlighterFirstTime(cmbColors.ItemIndex);
  devEditor.AssignEditor(synExample, 'main.cpp');

  // Font options
  cmbFont.Items.Assign(Screen.Fonts);
  FontIndex := cmbFont.Items.IndexOf('Consolas');
  if FontIndex = -1 then
    FontIndex := cmbFont.Items.IndexOf('Courier New');
  if FontIndex = -1 then
    FontIndex := cmbFont.Items.IndexOf('Courier');
  cmbFont.ItemIndex := FontIndex; // set ItemIndex once

  // Populate language list
  UpdateLangList(Lang.GetLangList);
  lbLanguages.SetFocus;
end;

procedure TLangForm.ColorChange(Sender: TObject);
begin
  dmMain.InitHighlighterFirstTime(cmbColors.ItemIndex);

  // Pick a proper current line color (choice is up for debate...)
  {
  if cmbColors.Text = 'Obsidian' then
    devEditor.HighColor := clBlack
  else if cmbColors.Text = 'Twilight' then
    devEditor.HighColor := $202020
  else if cmbColors.Text = 'Borland' then
    devEditor.HighColor := $202020
  else if cmbColors.Text = 'Matrix' then
    devEditor.HighColor := $202020 // dark brown
  else if cmbColors.Text = 'GSS Hacker' then
    devEditor.HighColor := clBlack
  else if cmbColors.Text = 'Obvilion' then
    devEditor.HighColor := clBlack
  else if cmbColors.Text = 'PlasticCodeWrap' then
    devEditor.HighColor := clBlack
  else
    devEditor.HighColor := $FFFFCC; // Light Turquoise

    }
  devEditor.AssignEditor(synExample, 'main.cpp');
end;

procedure TLangForm.FontChange(Sender: TObject);
begin
  devEditor.Font.Name := cmbFont.Text;
  devEditor.Gutterfont.Name := cmbFont.Text;
  devEditor.AssignEditor(synExample, 'main.cpp');
end;

procedure TLangForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLangForm.cmbIconsChange(Sender: TObject);
begin
  if cmbIcons.ItemIndex = 1 then
    tbExample.Images := dmMain.MenuImages_Gnome
  else if cmbIcons.ItemIndex = 2 then
    tbExample.Images := dmMain.MenuImages_Blue
  else
    tbExample.Images := dmMain.MenuImages_NewLook;
end;

procedure TLangForm.cmbFontDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  alignleft: integer;
  aligntop: integer;
begin
  with TComboBox(Control) do begin
    Canvas.Font.Name := Items.Strings[Index];
    Canvas.Font.Size := devEditor.Font.Size;
    Canvas.FillRect(Rect);
    alignleft := (Rect.Right - Rect.Left) div 2 - Canvas.TextWidth(Canvas.Font.Name) div 2;
    aligntop := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - Canvas.TextHeight(Canvas.Font.Name) div 2;
    Canvas.TextOut(alignleft, aligntop, Canvas.Font.Name);
  end;
end;

end.

