# BVG Wallpaper 2026

Ứng dụng portable giúp tự đặt hình nền lịch chứng khoán Bò và Gấu 2026 theo đúng tháng hiện tại. Không cần cài đặt, không cần tài khoản, không chạy nền nếu người dùng không bật lịch tự động.

![BVG Wallpaper tháng 6](wallpapers/BVG-2026-06-Jun.jpg)

## Tải về nhanh

Cách đơn giản nhất cho khách hàng:

1. Tải file `BVG-Wallpaper-2026-portable.zip` trong mục **Releases** của GitHub.
2. Giải nén file zip.
3. Chạy file phù hợp với máy:
   - Windows: nhấn đúp `Run-Windows.cmd`
   - macOS: mở Terminal trong thư mục đã giải nén và chạy `./set-bvg-wallpaper.command`

Khi chạy, ứng dụng sẽ tự chọn ảnh lịch của tháng hiện tại và đặt làm hình nền desktop.

## Có gì trong bộ này?

- 12 ảnh lịch wallpaper năm 2026, từ tháng 1 đến tháng 12.
- Script Windows để đặt hình nền bằng PowerShell.
- Script macOS để đặt hình nền bằng AppleScript.
- Tùy chọn tải lại ảnh từ link gốc nếu thư mục ảnh bị thiếu.
- Tùy chọn tạo lịch tự chạy vào ngày 1 hằng tháng lúc 09:00.

Nguồn ảnh: [bài viết Bò và Gấu](https://bovagau.vn/bo-va-gau-tang-ban-bo-lich-chung-khoan-nam-2026-ne-1-125139)

## Hướng dẫn Windows

Nhấn đúp:

```text
Run-Windows.cmd
```

Nếu Windows hiện cảnh báo bảo mật, chọn **More info** rồi **Run anyway**. Đây là script PowerShell nội bộ để đổi hình nền, không phải file cài đặt.

Các tùy chọn nâng cao trong PowerShell:

```powershell
.\Set-BVGWallpaper.ps1
.\Set-BVGWallpaper.ps1 -Month 6
.\Set-BVGWallpaper.ps1 -DownloadAll
.\Set-BVGWallpaper.ps1 -InstallMonthlyTask
.\Set-BVGWallpaper.ps1 -RemoveMonthlyTask
```

Ý nghĩa:

- `-Month 6`: chọn ảnh tháng 6 thay vì tháng hiện tại.
- `-DownloadAll`: tải lại đủ 12 ảnh nếu cần.
- `-InstallMonthlyTask`: tự chạy vào ngày 1 hằng tháng lúc 09:00.
- `-RemoveMonthlyTask`: gỡ lịch tự chạy.

## Hướng dẫn macOS

Mở Terminal tại thư mục đã giải nén, rồi chạy:

```zsh
chmod +x ./set-bvg-wallpaper.command
./set-bvg-wallpaper.command
```

Các tùy chọn nâng cao:

```zsh
./set-bvg-wallpaper.command 6
./set-bvg-wallpaper.command --download-all
./set-bvg-wallpaper.command --install-reminder
./set-bvg-wallpaper.command --remove-reminder
```

Ý nghĩa:

- `6`: chọn ảnh tháng 6 thay vì tháng hiện tại.
- `--download-all`: tải lại đủ 12 ảnh nếu cần.
- `--install-reminder`: tự chạy vào ngày 1 hằng tháng lúc 09:00.
- `--remove-reminder`: gỡ lịch tự chạy.

## Link ảnh đã trích xuất

Danh sách URL trực tiếp nằm trong [`wallpapers.json`](wallpapers.json).

Theo bài viết gốc:

- `lich-2026_page-0001` là ảnh bìa.
- `lich-2026_page-0002` đến `lich-2026_page-0013` tương ứng tháng 1 đến tháng 12.

## Bản quyền và ghi chú

Đây là bộ đóng gói tiện ích không chính thức để người dùng cá nhân cài nhanh bộ lịch wallpaper. Hình ảnh thuộc về Bò và Gấu/đơn vị phát hành gốc. Vui lòng giữ nguồn khi chia sẻ.
