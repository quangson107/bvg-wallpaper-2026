# Cách tải và dùng BVG Wallpaper 2026

Bạn muốn đổi hình nền máy tính thành lịch chứng khoán Bò và Gấu đúng theo từng tháng? Bộ **BVG Wallpaper 2026** giúp bạn làm việc đó chỉ trong vài cú nhấp chuột.

Không cần cài đặt phần mềm. Không cần đăng nhập. Tải về, giải nén và chạy.

![BVG Wallpaper tháng 6](wallpapers/BVG-2026-06-Jun.jpg)

## Tải bộ wallpaper

Vào trang GitHub của dự án, mở mục **Releases**, rồi tải file:

```text
BVG-Wallpaper-2026-portable.zip
```

Sau khi tải xong, hãy giải nén file zip ra một thư mục bất kỳ trên máy tính.

## Dùng trên Windows

Trong thư mục vừa giải nén, nhấn đúp file:

```text
Run-Windows.cmd
```

Máy sẽ tự chọn ảnh lịch của tháng hiện tại và đặt làm hình nền desktop.

Nếu Windows hiện cảnh báo bảo mật, chọn **More info** rồi **Run anyway**. Bộ này không cài thêm phần mềm, chỉ chạy một script nhỏ để đổi hình nền.

## Dùng trên MacBook

Mở Terminal trong thư mục đã giải nén, chạy lần lượt:

```zsh
chmod +x ./set-bvg-wallpaper.command
./set-bvg-wallpaper.command
```

Máy sẽ tự chọn ảnh lịch của tháng hiện tại và đặt làm hình nền.

## Muốn tự nhắc vào đầu tháng?

Bạn có thể bật lịch tự chạy vào ngày 1 hằng tháng lúc 09:00.

Trên Windows, mở PowerShell trong thư mục đã giải nén và chạy:

```powershell
.\Set-BVGWallpaper.ps1 -InstallMonthlyTask
```

Trên macOS, mở Terminal trong thư mục đã giải nén và chạy:

```zsh
./set-bvg-wallpaper.command --install-reminder
```

Khi sang tháng mới, máy sẽ tự chạy lại để đổi sang ảnh lịch của tháng đó.

## Muốn chọn một tháng cụ thể?

Windows:

```powershell
.\Set-BVGWallpaper.ps1 -Month 6
```

macOS:

```zsh
./set-bvg-wallpaper.command 6
```

Thay số `6` bằng tháng bạn muốn, từ `1` đến `12`.

## Gỡ lịch tự động

Windows:

```powershell
.\Set-BVGWallpaper.ps1 -RemoveMonthlyTask
```

macOS:

```zsh
./set-bvg-wallpaper.command --remove-reminder
```

## Ghi chú

Bộ tiện ích này được đóng gói để người dùng tải và đổi wallpaper dễ hơn. Ảnh lịch thuộc về Bò và Gấu/đơn vị phát hành gốc. Nguồn bài viết: https://bovagau.vn/bo-va-gau-tang-ban-bo-lich-chung-khoan-nam-2026-ne-1-125139
