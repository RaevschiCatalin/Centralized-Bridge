import type { Config } from "tailwindcss";

export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        primary: '#0D0D0D',
        secondary: '#1F1F1F',
        highlight: '#BB86FC',
        accent: '#03DAC5',
        text: '#EAEAEA',
      },
    },
  },
  plugins: [],
} satisfies Config;
