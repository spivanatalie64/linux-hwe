# AcreetionOS Linux Kernel

This is the core kernel for **AcreetionOS**, developed under the **ArttulOS Project** umbrella.

## Project Overview

AcreetionOS is a Linux-based operating system focused on:
- **Chronic-pain-accessible OS development**: Designed with accessibility and user comfort as primary concerns
- **High availability**: Optimized for 99.9% uptime and exceptional stability
- **Modern hardware support**: Based on Hardware Enablement (HWE) philosophy to ensure compatibility with contemporary hardware

## Architecture

This kernel follows the standard Linux kernel layout with the following core directories:
- `/arch` - Architecture-specific code
- `/drivers` - Device drivers
- `/fs` - Filesystems
- `/include` - Header files
- `/init` - Initialization code
- `/ipc` - Inter-process communication
- `/kernel` - Core kernel code
- `/mm` - Memory management
- `/net` - Networking stack
- `/scripts` - Build and maintenance scripts

## Credits

**AcreetionOS** is developed and maintained by the **ArttulOS Project**.

Copyright (c) ArttulOS Project

## License

This project is licensed under the GNU General Public License v2.0 (GPL-2.0). See the LICENSE file for details.

## Building

Build instructions will be added as the kernel development progresses.

## Contributing

Contributions are welcome! Please ensure all code follows:
- Strict C11/C89 kernel-style coding standards
- No floating point operations in kernel space
- GPL-2.0 headers on all files
- Memory safety and defensive programming practices
