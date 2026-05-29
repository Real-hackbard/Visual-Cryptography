unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.Samples.Spin;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PaintBox1: TPaintBox;
    Image2: TImage;
    Image1: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Memo1: TMemo;
    Label9: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Image4: TImage;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bevel2: TBevel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SpinEdit4: TSpinEdit;
    Label8: TLabel;
    Button3: TButton;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Button4: TButton;
    procedure Edit1Change(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

var
  yalt, yoffset : integer;
  bewegen  :boolean;

{$R *.dfm}
{ Here, two images are superimposed for visualization purposes. The images
  must be of equal size and set to transparent so that the overlapping
  image covers the black pixels of the image beneath it, making them visible. }
procedure MergeBmp(Src1, Src2, Dest: TBitmap; Alpha: Byte);
type
  TARGB = packed record b, g, r, a: Byte end;
var
  s1, s2, d: ^TARGB;
  nAlpha: Byte;
  i: Integer;
begin
  if not (Assigned(Src1) or Assigned(Src2) or Assigned(Dest)) then Exit;
  if (Src1.Width<>Src2.Width) or (Src1.Height<>Src2.Height) then Exit;
  Src1.PixelFormat := pf32bit;
  Src2.PixelFormat := pf32bit;
  Dest.PixelFormat := pf32bit;
  Dest.Width:=Src1.Width;
  Dest.Height:=Src1.Height;
  s1:=Src1.ScanLine[Src1.Height-1];
  s2:=Src2.ScanLine[Src2.Height-1];
  d:=Dest.ScanLine[Dest.Height-1];

  nAlpha := not Alpha;

  // This ensures that the pixels possess the full color channel value.
  for i:=1 to Dest.Width*Dest.Height do
  begin
    d.b:=(s1.b*nAlpha + s2.b*Alpha) Div 255;
    d.g:=(s1.g*nAlpha + s2.g*Alpha) Div 255;
    d.r:=(s1.r*nAlpha + s2.r*Alpha) Div 255;
    Inc(s1);
    Inc(s2);
    Inc(d);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  case PageControl1.TabIndex of
    0 :begin
         SaveDialog1.FileName := 'Picture1';
         if SaveDialog1.Execute then
         begin
          Image1.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
         end;
       end;

    1 :begin
        OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'Example';
        if OpenDialog1.Execute then
        begin
         Image3.Picture.Bitmap.LoadFromFile(OpenDialog1.FileName);
        end;
      end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  case PageControl1.TabIndex of
    0 :begin
         SaveDialog1.FileName := 'Picture2';
         if SaveDialog1.Execute then
         begin
          Image2.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
         end;
       end;

    1 :begin
        OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'Example';
        if OpenDialog1.Execute then
        begin
         Image4.Picture.Bitmap.LoadFromFile(OpenDialog1.FileName);
        end;
      end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if FontDialog1.Execute then
  begin
    Edit1.OnChange(sender);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Image3.Picture.Graphic := nil;
  Image4.Picture.Graphic := nil;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Edit1.OnChange(sender);
  Application.ProcessMessages;
end;

procedure TForm1.Edit1Change(Sender: TObject);
const
  xb=200; // The area that is colored horizontally
  yb=100; // The area that is colored vertically
var
  bitmap, bl, br : TBitmap;
  i,j:integer;
  k:string;
  offset:integer;
begin
  // Determine pixels from image 1 as black.
  bl := TBitmap.create;
  bl.width := 2;
  bl.height := 2;
  bl.canvas.Pixels[0,0] := clBlack;
  bl.canvas.Pixels[1,1] := clBlack;

  // Determine pixels from image 2 as black.
  br := TBitmap.create;
  br.width :=2;
  br.height :=2;
  br.canvas.Pixels[0,1] := clBlack;
  br.canvas.Pixels[1,0] := clBlack;

  bitmap := TBitmap.create;
  bitmap.width := xb;
  bitmap.height:= yb;

  { The bitmaps must be drawn in a 1-pixel format to prevent smearing,
    as overlaps of 4-pixels or more will destroy the strings. }
  bitmap.PixelFormat:= pf1bit;  // not higher

  // bitmap text output styles
  bitmap.Canvas.brush.style:= bsClear;
  bitmap.Canvas.font.name:= FontDialog1.Font.Name;
  bitmap.Canvas.font.size := SpinEdit4.Value;

  // select style for bitmap output font
  case ComboBox1.ItemIndex of
    0 : bitmap.Canvas.font.style:= [];
    1 : bitmap.Canvas.font.style:= [fsbold];
    2 : bitmap.Canvas.font.style:= [fsItalic];
    3 : bitmap.Canvas.font.style:= [fsUnderline];
  end;

  // copy text to memo box
  k := Edit1.Text;

  { select font style for memo box, The style specifications have no
    significance for the images. If changes are made, the bitmap font
    must also be modified. }
  Memo1.clear;
  Memo1.font.size := 11;
  Memo1.font.style := [fsbold];
  Memo1.lines.add(k);

  { copy memo text to bitmap, The SpinEdit3 represents the font height.
    The others SpinEdits 1+2 represent the X and Y positions.

    Please note that the width of the Memo control on the form should not
    be changed; otherwise, the proportions will not work correctly.}
    for i:=0 to Memo1.Lines.Count-1 do
       bitmap.canvas.textout(SpinEdit1.Value,   // Y
                             SpinEdit2.Value+i* // X
                             SpinEdit3.Value,   // char height
                             Memo1.lines[i]);   // memo text lines

  // copy pixels from Image1 to Imag2
  Image2.picture.bitmap.assign(Image1.picture.bitmap);

  for i:=3 to xb do
    for j:=3 to yb do
    begin
      { Paint over the black pixels at X/Y with white paint, and go pixel by
        pixel across the entire image. In this process, the pixels of both
        images are processed simultaneously. Therefore, both images should
        have the same aspect ratio. }
      if bitmap.Canvas.pixels[i,j] <> clwhite then
      begin
        if Image1.Canvas.pixels[2*i,2*j] = clwhite then
          Image2.canvas.draw(2*i,2*j,bl)
        else
          Image2.canvas.draw(2*i,2*j,br);
      end;
    end;

    bitmap.free;
    bl.free;
    br.free;
     try
       bitmap:= TBitmap.create;
       bitmap.width := paintbox1.width;
       bitmap.height := paintbox1.height;
       offset:=(bitmap.width-Image1.width) div 4;

       { Here, the boundaries are determined and set to minus one pixel,
         ensuring that pixel (0,0) is either colored or left uncolored.
         The same applies to the bottom-right edge. }
       bitmap.canvas.Rectangle(-1,-1,bitmap.width+1,bitmap.height+1);

       // paint the pixel on both images
       bitmap.canvas.Draw(offset,50,Image1.picture.bitmap);
       bitmap.canvas.Draw(offset,yoffset,Image2.picture.bitmap);

       // Font output to the Paintbox
       bitmap.canvas.font.name:='Verdana';
       bitmap.canvas.brush.style:=bsclear;
       bitmap.canvas.font.size:=8;
       bitmap.Canvas.Font.Color := clMaroon;
       bitmap.canvas.textout(offset+15,25,'Picture 1 : Background Image');
       bitmap.Canvas.Font.Color := clNavy;
       bitmap.canvas.textout(offset+15,285,'Picture 2 : Overlapping Image');
       paintbox1.canvas.Draw(0,0,bitmap);
     finally
      bitmap.free;
     end;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  if PageControl1.TabIndex = 0 then
  begin
    Button1.Caption := 'Save Pic 1';
    Button2.Caption := 'Save Pic 2';
    Button3.Visible := true;
    Button4.Visible := false;
    GroupBox1.Visible := true;
    SpinEdit1.Visible := true;
    SpinEdit2.Visible := true;
    SpinEdit3.Visible := true;
    SpinEdit4.Visible := true;
    Label3.Visible := true;
    Label4.Visible := true;
    Label9.Visible := true;
    Label5.Visible := true;
    Label6.Visible := true;
    Label7.Visible := true;
    Label8.Visible := true;
    Bevel2.Visible := true;
  end;

  if PageControl1.TabIndex = 1 then
  begin
    Button1.Caption := 'Load Pic 1';
    Button2.Caption := 'Load Pic 2';
    Button3.Visible := false;
    Button4.Visible := true;
    GroupBox1.Visible := false;
    SpinEdit1.Visible := false;
    SpinEdit2.Visible := false;
    SpinEdit3.Visible := false;
    SpinEdit4.Visible := false;
    Label3.Visible := false;
    Label4.Visible := false;
    Label9.Visible := false;
    Label5.Visible := false;
    Label6.Visible := false;
    Label7.Visible := false;
    Label8.Visible := false;
    Bevel2.Visible := false;
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Determine the horizontal line of the lower image.
  yalt := y;
  bewegen := true;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   // Move Picture 2 in the horizontal direction.
   if bewegen then
   begin
     { The lower image aligns precisely with the top edge of the first image.
       In the event of a change, the position of the upper image must also
       be adjusted. }
     if yoffset+(y-yalt)<50 then
      yoffset := 50
     else
      yoffset:=yoffset+(y-yalt);

     yalt := y;
     Edit1Change(Sender);
   end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    bewegen:=false;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  Edit1.OnChange(sender);
  Application.ProcessMessages;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  Edit1.OnChange(sender);
  Application.ProcessMessages;
end;

procedure TForm1.SpinEdit3Change(Sender: TObject);
begin
  Edit1.OnChange(sender);
  Application.ProcessMessages;
end;

procedure TForm1.SpinEdit4Change(Sender: TObject);
begin
  Edit1.OnChange(sender);
  Application.ProcessMessages;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  // Horizontal position of the lower image
  yoffset := 310;
  bewegen := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FontDialog1.Font.Name := 'Impact';
  Image3.Transparent := true;
  Image4.Transparent := true;
end;

end.
