# POS Slip

- ใบกำกับภาษีแบบย่อ
- ใบกำกับภาษีแบบเต็ม
- ใบรับคืนสินค้า
- พิมพ์ครัว
- ใบสรุปการสั่งอาหาร(Checking Order List)

```json
{
  "name": "",
  "description": "",
  "header": [
    {
      "col": 2,
      "data": [
        {
          "data": "&qty&",
          "format": ""
        },
        {
          "width": "30%",
          "font_size": "",
          "bold": true,
          "italic": true,
          "underline": true,
          "align": "", // default left
          "data": "",
          "format": ""
        }
      ]
    }
  ],
  "items": [],
  "footer": []
}
```

## RowData

| Attribute Name | Description     | Type  |
| -------------- | --------------- | ----- |
| col            | จำนวน Column    | int   |
| data           | ข้อมูลที่จะแสดง | array |
|                |                 |       |

## CellData

## Typography

## ตัวแปร

| ชื่อตัวแปร | คำอธิบาย | type    | Default |
| ---------- | -------- | ------- | ------- |
| width      |          | text    |         |
| font_size  |          | float   |         |
| bold       |          | boolean |         |
| italic     |          | boolean |         |
| underline  |          | boolean |         |
| align      |          | text    |         |
| data       |          | text    |         |
| format     |          | text    |         |
