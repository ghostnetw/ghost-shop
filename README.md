# 🛒 ghost-shop

A modern, customizable, and user-friendly shop system for FiveM, built by **GhostNetw**.  
Seamlessly integrates with your server, supporting both cash and bank payments, with a beautiful NUI interface.

## ✨ Features

- ⚡ **Fast & Responsive UI**  
- 💳 **Multiple Payment Methods** (cash, bank)
- 🛠️ **Easy Configuration**  
- 🔒 **Secure Transaction Handling**  
- 🛒 **Supports Items & Weapons**  
- 🌐 **Locale/Language Support**  
- 🔔 **Custom Notifications & Sounds**  

## 📸 Preview
![alt text](<Screenshot 2025-04-30 121347.png>)
> _Add a screenshot or GIF of your shop UI here!_

## 🚀 Installation

1. **Clone or Download**
   ```bash
   git clone https://github.com/ghostnetw/ghost-shop.git
   ```

2. **Add to Your Server**
   - Place the `ghost-shop` folder in your server's `resources` directory.

3. **Add to `server.cfg`**
   ```
   ensure ghost-shop
   ```

4. **Configure**
   - Edit `config/cfg_main.lua` and other config files to suit your server's needs.

## ⚙️ Configuration

- **Main Config:**  
  `config/cfg_main.lua` – Set up shop locations, items, prices, and more.
- **Locales:**  
  `config/cfg_locales.lua` – Customize language and messages.
- **Functions:**  
  `config/cfg_functions.lua` – Advanced logic and hooks.

## 🧑‍💻 Usage

- Open the shop in-game at configured locations.
- Select items, choose payment method, and confirm purchase.
- Enjoy instant feedback and notifications!

## 🛠️ Development

- **Client scripts:** `client/`
- **Server scripts:** `server/`
- **UI (NUI):** `web/`

## ❓ Support

- For issues, open a [GitHub Issue](https://github.com/ghostnetw/ghost-shop/issues).

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

> _Made with ❤️ by GhostNetw_

Let me know if you want to add badges, images, or more advanced sections!
