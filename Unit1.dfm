object Form1: TForm1
  Left = 205
  Top = 149
  Width = 673
  Height = 507
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 4
    Width = 11
    Height = 13
    Caption = 'W'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 22
    Height = 13
    Caption = 'OSC'
  end
  object Label3: TLabel
    Left = 84
    Top = 8
    Width = 13
    Height = 13
    Caption = 'Hz'
  end
  object Edit1: TEdit
    Left = 0
    Top = 36
    Width = 45
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 44
    Top = 36
    Width = 53
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 384
    Top = 444
    Width = 38
    Height = 17
    Caption = 'Step'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 424
    Top = 444
    Width = 60
    Height = 17
    Caption = 'Step Over'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 0
    Top = 56
    Width = 45
    Height = 200
    ItemHeight = 13
    TabOrder = 4
  end
  object ListBox2: TListBox
    Left = 44
    Top = 56
    Width = 53
    Height = 200
    ItemHeight = 13
    TabOrder = 5
  end
  object Button3: TButton
    Left = 344
    Top = 444
    Width = 38
    Height = 17
    Caption = 'Reset'
    TabOrder = 6
  end
  object Edit3: TEdit
    Left = 96
    Top = 36
    Width = 61
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object Button4: TButton
    Left = 488
    Top = 376
    Width = 57
    Height = 17
    Caption = 'Test 2'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 536
    Top = 4
    Width = 57
    Height = 17
    Caption = 'File'
    TabOrder = 9
    OnClick = Button5Click
  end
  object Edit4: TEdit
    Left = 156
    Top = 36
    Width = 81
    Height = 21
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
  end
  object Edit5: TEdit
    Left = 192
    Top = 4
    Width = 53
    Height = 21
    TabOrder = 11
  end
  object Edit6: TEdit
    Left = 252
    Top = 4
    Width = 169
    Height = 21
    TabOrder = 12
  end
  object Edit7: TEdit
    Left = 424
    Top = 4
    Width = 57
    Height = 21
    TabOrder = 13
  end
  object Button6: TButton
    Left = 612
    Top = 444
    Width = 49
    Height = 17
    Caption = 'Exit'
    TabOrder = 14
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 484
    Top = 4
    Width = 49
    Height = 17
    Caption = 'Test'
    TabOrder = 15
    OnClick = Button7Click
  end
  object Edit8: TEdit
    Left = 348
    Top = 416
    Width = 185
    Height = 21
    TabOrder = 16
  end
  object Edit9: TEdit
    Left = 348
    Top = 392
    Width = 57
    Height = 21
    TabOrder = 17
  end
  object Edit10: TEdit
    Left = 408
    Top = 392
    Width = 125
    Height = 21
    TabOrder = 18
  end
  object Edit11: TEdit
    Left = 536
    Top = 392
    Width = 41
    Height = 21
    TabOrder = 19
  end
  object ListBox3: TListBox
    Left = 96
    Top = 56
    Width = 61
    Height = 200
    ItemHeight = 13
    TabOrder = 20
  end
  object ListBox4: TListBox
    Left = 156
    Top = 56
    Width = 81
    Height = 200
    ItemHeight = 13
    TabOrder = 21
  end
  object Button8: TButton
    Left = 344
    Top = 376
    Width = 53
    Height = 17
    Caption = 'Memory'
    TabOrder = 22
    OnClick = Button8Click
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 376
    Width = 342
    Height = 85
    Color = cl3DLight
    ColCount = 17
    DefaultColWidth = 18
    DefaultRowHeight = 16
    RowCount = 17
    TabOrder = 23
  end
  object StringGrid2: TStringGrid
    Left = 0
    Top = 260
    Width = 546
    Height = 115
    Color = cl3DLight
    ColCount = 17
    Ctl3D = True
    DefaultColWidth = 30
    DefaultRowHeight = 15
    FixedColor = clSilver
    RowCount = 513
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 24
  end
  object Button9: TButton
    Left = 400
    Top = 376
    Width = 57
    Height = 17
    Caption = 'Programs'
    TabOrder = 25
    OnClick = Button9Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 463
    Width = 665
    Height = 18
    Panels = <>
    SimplePanel = False
  end
  object Button10: TButton
    Left = 488
    Top = 444
    Width = 38
    Height = 17
    Caption = 'GoTo'
    TabOrder = 27
  end
  object ListBox5: TListBox
    Left = 544
    Top = 260
    Width = 49
    Height = 125
    Color = cl3DLight
    ItemHeight = 13
    TabOrder = 28
  end
  object UpDown1: TUpDown
    Left = 236
    Top = 56
    Width = 17
    Height = 201
    Min = 0
    Position = 0
    TabOrder = 29
    Wrap = False
  end
  object Button11: TButton
    Left = 592
    Top = 396
    Width = 53
    Height = 17
    Caption = 'Button11'
    TabOrder = 30
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 592
    Top = 412
    Width = 53
    Height = 17
    Caption = 'Button12'
    TabOrder = 31
  end
  object OpenDialog1: TOpenDialog
    Left = 540
    Top = 4
  end
end
