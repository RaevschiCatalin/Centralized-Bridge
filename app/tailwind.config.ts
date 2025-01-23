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
        primary: "#0d1117",
        secondary: "#161b22",
        highlight: '#BB86FC',
        accent: '#03DAC5',
        text: "#c9d1d9",
      },
    },
  },
  plugins: [],
} satisfies Config;
