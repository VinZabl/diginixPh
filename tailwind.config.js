/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        cafe: {
          accent: '#E74694', // Pink accent
          dark: '#0A0A0A', // Off-black background
          cream: '#F5F5F5',
          beige: '#E5E5E5',
          latte: '#D5D5D5',
          espresso: '#E74694',
          light: '#1A1A1A',
          // Kitty Galore theme colors
          primary: '#E74694', // Pink primary
          secondary: '#F05BA8', // Slightly lighter pink
          darkBg: '#FFF5F5', // Off-light pink main background
          darkCard: '#FFF9F9', // Slightly darker card background
          glass: 'rgba(231, 70, 148, 0.1)', // Glass effect with accent color
          text: '#2D1B2E', // Dark text for light background
          textMuted: '#5A4A5B' // Muted text
        }
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.4s ease-out',
        'bounce-gentle': 'bounceGentle 0.6s ease-out',
        'scale-in': 'scaleIn 0.3s ease-out'
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' }
        },
        bounceGentle: {
          '0%, 20%, 50%, 80%, 100%': { transform: 'translateY(0)' },
          '40%': { transform: 'translateY(-4px)' },
          '60%': { transform: 'translateY(-2px)' }
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' }
        }
      }
    },
  },
  plugins: [],
};