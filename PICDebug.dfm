object PICForm: TPICForm
  Left = 194
  Top = 106
  Width = 800
  Height = 559
  Caption = 'PIC Lab'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 72
    Width = 11
    Height = 13
    Caption = 'W'
    Color = clRed
    ParentColor = False
  end
  object Label2: TLabel
    Left = 560
    Top = 224
    Width = 49
    Height = 13
    Caption = 'OSC in Hz'
  end
  object Label3: TLabel
    Left = 496
    Top = 192
    Width = 58
    Height = 13
    Caption = 'Time in mkS'
  end
  object Button1: TButton
    Left = 324
    Top = 76
    Width = 40
    Height = 17
    Caption = 'Step'
    TabOrder = 0
    OnClick = Button1Click
  end
  object StepOwer: TButton
    Left = 324
    Top = 96
    Width = 85
    Height = 17
    Caption = 'Step Over'
    TabOrder = 1
    OnClick = StepOwerClick
  end
  object ResetBtn: TButton
    Left = 412
    Top = 96
    Width = 40
    Height = 17
    Caption = 'Reset'
    TabOrder = 2
    OnClick = ResetBtnClick
  end
  object Button5: TButton
    Left = 712
    Top = 192
    Width = 33
    Height = 21
    Caption = 'File'
    TabOrder = 3
    OnClick = Button5Click
  end
  object Edit5: TEdit
    Left = 12
    Top = 72
    Width = 19
    Height = 21
    TabOrder = 4
    Text = '00'
  end
  object Edit6: TEdit
    Left = 556
    Top = 192
    Width = 153
    Height = 21
    TabOrder = 5
    Text = 'SAFIRMX.HEX'
  end
  object Edit7: TEdit
    Left = 728
    Top = 52
    Width = 61
    Height = 21
    TabOrder = 6
  end
  object Button7: TButton
    Left = 740
    Top = 120
    Width = 49
    Height = 17
    Caption = 'Test'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Edit8: TEdit
    Left = 736
    Top = 168
    Width = 53
    Height = 21
    TabOrder = 8
  end
  object Edit10: TEdit
    Left = 728
    Top = 28
    Width = 61
    Height = 21
    TabOrder = 9
  end
  object Edit11: TEdit
    Left = 736
    Top = 140
    Width = 53
    Height = 21
    TabOrder = 10
  end
  object Button8: TButton
    Left = 728
    Top = 444
    Width = 53
    Height = 17
    Caption = 'Memory'
    TabOrder = 11
    OnClick = Button8Click
  end
  object DataMemoryGrid: TStringGrid
    Left = 420
    Top = 244
    Width = 353
    Height = 88
    Hint = #1055#1072#1084#1103#1090#1100' '#1076#1072#1085#1085#1099#1093' '#1042#1085#1091#1090#1088#1077#1085#1085#1077#1077' '#1054#1047#1059'-'#1056#1077#1075#1080#1090#1088#1099
    Color = clMoneyGreen
    ColCount = 17
    DefaultColWidth = 18
    DefaultRowHeight = 16
    RowCount = 33
    TabOrder = 12
    OnClick = DataMemoryGridClick
    OnKeyPress = DataMemoryGridKeyPress
    ColWidths = (
      29
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18)
  end
  object ProgramFlashGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 546
    Height = 69
    Hint = #1055#1072#1084#1103#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084
    Color = clInfoBk
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
    TabOrder = 13
  end
  object Button9: TButton
    Left = 728
    Top = 464
    Width = 57
    Height = 17
    Caption = 'Programs'
    TabOrder = 14
    OnClick = Button9Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 490
    Width = 792
    Height = 23
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Alignment = taRightJustify
        Width = 80
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Button10: TButton
    Left = 368
    Top = 76
    Width = 40
    Height = 17
    Caption = 'GoTo'
    TabOrder = 16
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 688
    Top = 120
    Width = 53
    Height = 17
    Caption = 'Button11'
    TabOrder = 17
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 736
    Top = 76
    Width = 53
    Height = 17
    Caption = 'Button12'
    TabOrder = 18
    OnClick = Button12Click
  end
  object CBPort: TComboBox
    Left = 548
    Top = 0
    Width = 53
    Height = 21
    Hint = #1042#1099#1073#1086#1088' '#1085#1086#1084#1077#1088#1072' '#1087#1086#1088#1090#1072
    ItemHeight = 13
    TabOrder = 19
    Text = 'COM2 (*)'
    Items.Strings = (
      'COM1'
      'COM2 (*)'
      'COM3'
      'COM4'
      'COM5'
      'COM6'
      'COM7'
      'COM8')
  end
  object CBBaud: TComboBox
    Left = 548
    Top = 24
    Width = 65
    Height = 21
    Hint = #1057#1082#1086#1088#1086#1089#1090#1100' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086#1075#1086' '#1087#1086#1088#1090#1072
    ItemHeight = 13
    TabOrder = 20
    Text = '9600 (*)'
    Items.Strings = (
      '100'
      '300'
      '600'
      '1200'
      '2400'
      '4800'
      '9600 (*)'
      '14400'
      '19200'
      '38400'
      '56000'
      '115200'
      '128000'
      '256000')
  end
  object CBFlow: TComboBox
    Left = 548
    Top = 48
    Width = 77
    Height = 21
    Hint = #1050#1086#1085#1090#1088#1086#1083#1100' '#1086#1073#1084#1077#1085#1072
    ItemHeight = 13
    TabOrder = 21
    Text = 'None (*)'
    Items.Strings = (
      'None (*)'
      'XOn-XOff'
      'RTS-CTS'
      'DSR-DTR')
  end
  object EEPROMGrid: TStringGrid
    Left = 420
    Top = 332
    Width = 353
    Height = 88
    Color = clAqua
    ColCount = 17
    DefaultColWidth = 18
    DefaultRowHeight = 15
    RowCount = 17
    TabOrder = 22
    ColWidths = (
      28
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18)
  end
  object Button13: TButton
    Left = 728
    Top = 424
    Width = 49
    Height = 17
    Caption = 'EEPROM'
    TabOrder = 23
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 604
    Top = 0
    Width = 29
    Height = 21
    Caption = 'Set'
    TabOrder = 24
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 616
    Top = 24
    Width = 17
    Height = 21
    Caption = '-'
    TabOrder = 25
    OnClick = Button15Click
  end
  object Edit12: TEdit
    Left = 668
    Top = 140
    Width = 65
    Height = 21
    TabOrder = 26
    Text = 'Edit12'
  end
  object Button16: TButton
    Left = 736
    Top = 96
    Width = 53
    Height = 17
    Caption = 'Button16'
    TabOrder = 27
  end
  object Edit13: TEdit
    Left = 668
    Top = 168
    Width = 65
    Height = 21
    TabOrder = 28
    Text = 'Edit13'
  end
  object WRegGrid: TStringGrid
    Left = 32
    Top = 72
    Width = 115
    Height = 39
    ColCount = 8
    DefaultColWidth = 13
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    ScrollBars = ssNone
    TabOrder = 29
    ColWidths = (
      13
      13
      13
      13
      13
      13
      13
      13)
  end
  object Edit14: TEdit
    Left = 4
    Top = 92
    Width = 27
    Height = 21
    TabOrder = 30
    Text = '0'
  end
  object StatusGrid: TStringGrid
    Left = 148
    Top = 72
    Width = 174
    Height = 39
    Hint = 'STATUS REGISTER'
    ColCount = 8
    DefaultColWidth = 13
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 31
    ColWidths = (
      25
      26
      27
      19
      20
      13
      20
      13)
  end
  object TraceGrid: TStringGrid
    Left = 0
    Top = 116
    Width = 417
    Height = 373
    Color = clInfoBk
    ColCount = 6
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 8194
    TabOrder = 32
    ColWidths = (
      31
      32
      63
      49
      158
      59)
  end
  object SteckGrid: TStringGrid
    Left = 456
    Top = 96
    Width = 35
    Height = 144
    ColCount = 1
    DefaultColWidth = 31
    DefaultRowHeight = 14
    FixedCols = 0
    RowCount = 9
    ScrollBars = ssNone
    TabOrder = 33
    RowHeights = (
      19
      14
      14
      14
      14
      14
      14
      14
      14)
  end
  object Edit2: TEdit
    Left = 496
    Top = 204
    Width = 60
    Height = 21
    TabOrder = 34
    Text = '1843200'
  end
  object ResetCLK: TButton
    Left = 496
    Top = 225
    Width = 60
    Height = 17
    Caption = 'ResetCLK'
    TabOrder = 35
    OnClick = ResetCLKClick
  end
  object PortGrid: TStringGrid
    Left = 496
    Top = 72
    Width = 169
    Height = 117
    ColCount = 9
    DefaultColWidth = 13
    DefaultRowHeight = 15
    RowCount = 7
    ScrollBars = ssNone
    TabOrder = 36
    ColWidths = (
      51
      13
      13
      13
      13
      13
      13
      13
      13)
    RowHeights = (
      15
      15
      15
      15
      15
      15
      15)
  end
  object Button4: TButton
    Left = 688
    Top = 92
    Width = 45
    Height = 17
    Caption = 'Button4'
    TabOrder = 37
  end
  object Edit3: TEdit
    Left = 408
    Top = 75
    Width = 45
    Height = 21
    TabOrder = 38
    Text = '0'
  end
  object Button17: TButton
    Left = 692
    Top = 60
    Width = 25
    Height = 13
    Caption = '+'
    TabOrder = 39
    OnClick = Button17Click
  end
  object Button18: TButton
    Left = 692
    Top = 76
    Width = 25
    Height = 13
    Caption = '-'
    TabOrder = 40
  end
  object Float32Grid: TStringGrid
    Left = 424
    Top = 452
    Width = 109
    Height = 33
    ColCount = 2
    DefaultColWidth = 55
    DefaultRowHeight = 13
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 41
    ColWidths = (
      32
      71)
  end
  object Edit4: TEdit
    Left = 456
    Top = 432
    Width = 45
    Height = 21
    TabOrder = 42
    Text = '0'
  end
  object Button3: TButton
    Left = 456
    Top = 76
    Width = 37
    Height = 17
    Caption = 'Run'
    TabOrder = 43
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 728
    Top = 4
    Width = 61
    Height = 21
    TabOrder = 44
    Text = '14'
    OnChange = Edit1Change
  end
  object Button2: TButton
    Left = 640
    Top = 0
    Width = 49
    Height = 17
    Caption = 'SeveList'
    TabOrder = 45
    OnClick = Button2Click
  end
  object Edit9: TEdit
    Left = 640
    Top = 16
    Width = 85
    Height = 21
    TabOrder = 46
    Text = 'Edit9'
  end
  object Edit15: TEdit
    Left = 420
    Top = 116
    Width = 33
    Height = 21
    TabOrder = 47
    Text = '75'
  end
  object Listing: TComboBox
    Left = 640
    Top = 40
    Width = 85
    Height = 21
    ItemHeight = 13
    TabOrder = 48
    Text = 'ASM'
    Items.Strings = (
      'ASM'
      'LST'
      'LST+DAT'
      'ASM+COMENT'
      'LST+COMENT')
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.hex (HEX8s format)|*.hex'
    Left = 676
    Top = 192
  end
  object SerialPort1: TSerialPort
    StripNullChars = True
    AfterReceive = SerialPort1AfterReceive
    Left = 556
    Top = 16
  end
  object MainMenu: TMainMenu
    Left = 4
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object OpenHEX1: TMenuItem
        Caption = 'Open HEX'
        ShortCut = 16463
        OnClick = OpenHEX1Click
      end
      object SaveHEX1: TMenuItem
        Caption = 'Save HEX'
        ShortCut = 16467
      end
      object SaveListing1: TMenuItem
        Caption = 'Save Listing'
        ShortCut = 16460
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object Debug1: TMenuItem
      Caption = 'Debug'
      object Step1: TMenuItem
        AutoHotkeys = maAutomatic
        Caption = 'Step'
        ShortCut = 118
        OnClick = Button1Click
      end
      object StepOver1: TMenuItem
        Caption = 'Step Over'
        ShortCut = 119
        OnClick = StepOwerClick
      end
      object Reset1: TMenuItem
        Caption = 'Reset'
        ShortCut = 113
        OnClick = ResetBtnClick
      end
      object Goto1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Go to'
        ShortCut = 116
        OnClick = Button10Click
      end
      object RunF91: TMenuItem
        AutoHotkeys = maAutomatic
        Caption = 'Run'
        ShortCut = 120
        OnClick = Button3Click
      end
      object SetBP1: TMenuItem
        Caption = 'Set BP'
        ShortCut = 115
      end
      object DelBP1: TMenuItem
        Caption = 'Del BP'
        ShortCut = 114
      end
    end
    object Edit16: TMenuItem
      Caption = 'Edit'
      object Cut1: TMenuItem
        Caption = 'Cut'
      end
      object Copy1: TMenuItem
        Caption = 'Copy'
      end
      object Past1: TMenuItem
        Caption = 'Past'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object HelpPICLab1: TMenuItem
        Caption = 'Help PIC Lab'
      end
      object Abaut1: TMenuItem
        Caption = 'Abaut'
      end
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Untitled.lst'
    Filter = '*.lst|*.lst'
    Left = 684
    Top = 16
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Button1Click
    Left = 416
    Top = 28
  end
end
