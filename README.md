# 🛒 Lab 10: Flutter API Data Management (CRUD)

โปรเจกต์นี้เป็นส่วนหนึ่งของรายวิชา **การพัฒนาแอปพลิเคชันด้วย Flutter** มีวัตถุประสงค์เพื่อศึกษาและเรียนรู้การจัดการข้อมูลผ่าน **Web API (RESTful API)** โดยใช้ **FakeStoreAPI** เป็นฐานข้อมูลจำลอง และจัดการสถานะของแอปพลิเคชันด้วย **Provider**

---

## 🛠 เทคโนโลยีที่ใช้ (Technologies Used)

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Networking:** [HTTP Package](https://pub.dev/packages/http)
* **Backend Service:** [FakeStoreAPI](https://fakestoreapi.com)

---

## 📱 การทำงานของระบบ (System Functionalities)

ระบบถูกออกแบบมาให้มีการแบ่งสิทธิ์ผู้ใช้งาน (Role-based Access) ออกเป็น 2 ส่วนหลัก โดยใช้การตรวจสอบ Username จาก API:

### 🔑 1. ระบบ Login (Authentication)
* โหลดข้อมูลผู้ใช้จาก `/users` เพื่อตรวจสอบความถูกต้อง
* **Logic การเข้าหน้าจอ:**
    * หาก Login ด้วย **username: johnd** ➔ เข้าสู่หน้า **User Management (Admin)**
    * หาก Login ด้วย **User อื่นๆ** ➔ เข้าสู่หน้า **Product List (User)**

### 🛍️ 2. สำหรับผู้ใช้ทั่วไป (User Mode)
* **Product List:** แสดงรายการสินค้าทั้งหมด (รูปภาพ, ชื่อ, ราคา) ที่ดึงมาจาก API
* **Product Detail:** แสดงรายละเอียดสินค้าฉบับเต็ม
* **Cart System:** ระบบตะกร้าสินค้าที่สามารถ:
    * เพิ่ม/ลด จำนวนสินค้า
    * ลบสินค้าออกจากตะกร้า
    * คำนวณราคารวม (Total Price) โดยอัตโนมัติ

### ⚡ 3. สำหรับผู้ดูแลระบบ (Admin Mode)
สิทธิ์เฉพาะ Admin (johnd) เท่านั้นที่สามารถจัดการข้อมูลผู้ใช้ผ่าน CRUD Operations:
* **GET:** ดึงรายการผู้ใช้ทั้งหมด
* **POST:** เพิ่มข้อมูลผู้ใช้ใหม่
* **PUT:** แก้ไขข้อมูลผู้ใช้
* **DELETE:** ลบข้อมูลผู้ใช้ออกจากระบบ

---

## 🛰️ การจัดการ API (API Operations)

| Operation | Endpoint | Method | Description |
| :--- | :--- | :--- | :--- |
| **Read Users** | `/users` | `GET` | ดึงข้อมูลผู้ใช้ทั้งหมด |
| **Create User** | `/users` | `POST` | เพิ่มผู้ใช้ใหม่เข้าสู่ระบบ |
| **Update User** | `/users/{id}` | `PUT` | แก้ไขข้อมูลผู้ใช้ตาม ID |
| **Delete User** | `/users/{id}` | `DELETE` | ลบข้อมูลผู้ใช้ตาม ID |

---

## 🏗️ การจัดการสถานะ (State Management)

โปรเจกต์นี้ใช้ **Provider** ในการบริหารจัดการข้อมูลในแต่ละส่วนเพื่อให้แอปพลิเคชันทำงานได้อย่างลื่นไหล:

* **UserProvider:** จัดการข้อมูลการเข้าสู่ระบบ (Auth) และฟังก์ชัน CRUD ของ Admin
* **ProductProvider:** จัดการการดึงข้อมูลสินค้าและการแสดงผลในหน้าหลัก
* **CartProvider:** จัดการ Logic ในตะกร้าสินค้าและการคำนวณราคาทั้งหมด

## รูปภาพ
# Login
<img width="483" height="1006" alt="Image" src="https://github.com/user-attachments/assets/57316bea-5531-4b59-be2c-6a6b49ae53f0" />

# User Management (Admin เท่านั้น)
<img width="473" height="1006" alt="Image" src="https://github.com/user-attachments/assets/39d50c80-06d5-4149-acab-9cf3c1e42c7e" />

# Add form
<img width="469" height="987" alt="Image" src="https://github.com/user-attachments/assets/40529bfd-a9b6-47f4-80bf-76bd6436fe8d" />

# Product 
<img width="463" height="994" alt="Image" src="https://github.com/user-attachments/assets/d0aa7840-b678-4f17-ad9d-98944ccd4c45" />

# Product Details
<img width="479" height="997" alt="Image" src="https://github.com/user-attachments/assets/e71b463a-ea72-4d48-bf7f-8bb9fdddd960" />

# ระบบตะกร้าสินค้า (Cart)
<img width="475" height="1015" alt="Image" src="https://github.com/user-attachments/assets/31e5ca20-db50-49f4-a1ac-dac61f2ea726" />
---

## 📂 โครงสร้างโปรเจกต์ (Folder Structure)

```text
lib/
├── models/         # คลาสข้อมูล (ProductModel, UserModel)
├── services/       # ส่วนเชื่อมต่อ API (ProductApiService, UserApiService)
├── providers/      # การจัดการ State (UserProvider, ProductProvider, CartProvider)
├── screens/        # หน้าจอ UI (Login, Product, Cart, Admin)
└── main.dart       # จุดเริ่มต้นแอปและ Setup MultiProvider
---

