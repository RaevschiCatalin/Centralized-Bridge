import { Providers } from "./providers";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";


const geist = Geist({ subsets: ["latin"], variable: "--font-geist" });
const geistMono = Geist_Mono({ subsets: ["latin"], variable: "--font-geist-mono" });



export const metadata = {
    title: "Sui Blockchain App",
    description: "A decentralized app using Sui blockchain",
};

export default function RootLayout({
                                       children,
                                   }: {
    children: React.ReactNode;
}) {
    return (
        <html lang="en" className={`${geist.variable} ${geistMono.variable}`}>
        <body>
        <Providers>
            {children}
        </Providers>
        </body>
        </html>
    );
}
