# Visual-Cryptography

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)  ![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![None](https://github.com/user-attachments/assets/30ebe930-c928-4aaf-a8e1-5f68ec1ff349)  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) <img src="https://github.com/user-attachments/assets/ee0e6153-71cb-4519-82d8-80c83a2ac42e" />  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) <img src="https://github.com/user-attachments/assets/e6d6e119-9dd3-4cc1-b128-ebe698368325" />  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

One of the best-known techniques has been credited to Moni Naor and Adi Shamir, who developed it in 1994. They demonstrated a visual [secret sharing](https://en.wikipedia.org/wiki/Secret_sharing) scheme, where a [binary image](https://en.wikipedia.org/wiki/Binary_image) was broken up into n shares so that only someone with all n shares could decrypt the image, while any n − 1 shares revealed no information about the original image. Each share was printed on a separate transparency, and decryption was performed by overlaying the shares. When all n shares were overlaid, the original image would appear. There are several generalizations of the basic scheme including k-out-of-n visual cryptography, and using opaque sheets but illuminating them by multiple sets of identical illumination patterns under the recording of only one single-pixel detector, which exposed the image.

Using a similar idea, transparencies can be used to implement a [one-time pad](https://en.wikipedia.org/wiki/One-time_pad) encryption, where one transparency is a shared random pad, and another transparency acts as the ciphertext. Normally, there is an expansion of space requirement in visual cryptography. But if one of the two shares is structured recursively, the efficiency of visual cryptography can be increased to 100%

</br>

<img src="https://github.com/user-attachments/assets/a7a7edc6-bdfd-4721-8860-afd7858e90f2" />

</br></br>

In this example, the binary image has been split into two component images. Each component image has a pair of pixels for every pixel in the original image. These pixel pairs are shaded black or white according to the following rule: if the original image pixel was black, the pixel pairs in the component images must be complementary; randomly shade one ■□, and the other □■. When these complementary pairs are overlapped, they will appear dark gray. On the other hand, if the original image pixel was white, the pixel pairs in the component images must match: both ■□ or both □■. When these matching pairs are overlapped, they will appear light gray.

So, when the two component images are superimposed, the original image appears. However, without the other component, a component image reveals no information about the original image; it is indistinguishable from a random pattern of ■□ / □■ pairs. Moreover, if you have one component image, you can use the shading rules above to produce a counterfeit component image that combines with it to produce any image at all.

</br>

### Demonstration of visual cryptography

<img width="339" height="100" alt="Visual_crypto_animation_demo" src="https://github.com/user-attachments/assets/87082f8a-8471-4b14-bdd2-a8370bf32a1e" />

</br></br>

Any two transparencies printed with black rectangles, when overlaid reveals the message, here, a letter A (gridlines added for clarity).

</br>

<img width="400" height="225" alt="Visual_cryptography_3_choose_2 svg" src="https://github.com/user-attachments/assets/b01ae91f-6902-4eec-9b68-0ea67daac01e" />

</b></br>

Every pixel from the secret image is encoded into multiple subpixels in each share image using a matrix to determine the color of the pixels. In the (2, n) case, a white pixel in the secret image is encoded using a matrix from the following set, where each row gives the subpixel pattern for one of the components:

For instance in the (2,2) sharing case (the secret is split into 2 shares and both shares are required to decode the secret) we use complementary matrices to share a black pixel and identical matrices to share a white pixel. Stacking the shares we have all the subpixels associated with the black pixel now black while 50% of the subpixels associated with the white pixel remain white.

2×2 subpixels can also encode a binary image in each component image. For example, each white pixel of each component image could be represented by two black subpixels, while each black pixel represented by three black subpixels.

When overlaid, each white pixel of the secret image is represented by three black subpixels, while each black pixel is represented by all four subpixels black. Each corresponding pixel in the component images is randomly rotated to avoid orientation leaking information about the secret image.

</br>

<img width="400" height="400" alt="Visual_cryptography_stenography svg" src="https://github.com/user-attachments/assets/92fa432c-1d64-4056-9136-7243c5ce236d" />

</br></br>

Overlaying component images using two black subpixels (with letters A and B) to reveal a hidden message with three black subpixels (the letter S)

# Code
The images must be painted in a 1-pixel format to achieve the distinct black-and-white effect. Any higher resolution blurs the pixels and results in inconsistencies.

```pascal
  bitmap.PixelFormat:= pf1bit;  // not higher
```

Painting the Pixels

```pascal
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
```



