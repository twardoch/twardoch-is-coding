// this_file: src_slides/mdx/theme.js

export const theme = {
  colors: {
    text: '#ffffff',
    background: '#1e1e1e',
    primary: '#2196f3',
    secondary: '#00bcd4',
    accent: '#ff9800',
    muted: '#2d2d30',
    gray: '#cccccc',
  },
  fonts: {
    body: '"Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    heading: '"Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    monospace: 'Consolas, Monaco, "Courier New", monospace',
  },
  fontSizes: [12, 14, 16, 20, 24, 32, 48, 64, 96],
  fontWeights: {
    body: 400,
    heading: 700,
    bold: 700,
  },
  lineHeights: {
    body: 1.5,
    heading: 1.25,
  },
  space: [0, 4, 8, 16, 32, 64, 128, 256, 512],
  sizes: {
    container: 1280,
  },
  breakpoints: ['40em', '52em', '64em'],
  radii: {
    default: 4,
    circle: 99999,
  },
  shadows: {
    card: '0 0 4px rgba(0, 0, 0, .125)',
    large: '0 0 24px rgba(0, 0, 0, .125)',
  },
  // MDX Deck specific
  googleFont: 'https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Roboto+Mono&display=swap',
  styles: {
    root: {
      fontFamily: 'body',
      lineHeight: 'body',
      fontWeight: 'body',
    },
    h1: {
      color: 'primary',
      fontFamily: 'heading',
      lineHeight: 'heading',
      fontWeight: 'heading',
      fontSize: 6,
      marginBottom: 3,
    },
    h2: {
      color: 'secondary',
      fontFamily: 'heading',
      lineHeight: 'heading',
      fontWeight: 'heading',
      fontSize: 5,
      marginBottom: 3,
    },
    h3: {
      color: 'text',
      fontFamily: 'heading',
      lineHeight: 'heading',
      fontWeight: 'heading',
      fontSize: 4,
      marginBottom: 3,
    },
    h4: {
      color: 'text',
      fontFamily: 'heading',
      lineHeight: 'heading',
      fontWeight: 'heading',
      fontSize: 3,
      marginBottom: 2,
    },
    p: {
      color: 'text',
      fontFamily: 'body',
      fontWeight: 'body',
      lineHeight: 'body',
      marginBottom: 3,
    },
    a: {
      color: 'secondary',
      textDecoration: 'none',
      '&:hover': {
        textDecoration: 'underline',
      },
    },
    pre: {
      fontFamily: 'monospace',
      overflowX: 'auto',
      code: {
        color: 'inherit',
      },
      backgroundColor: 'muted',
      padding: 3,
      borderRadius: 'default',
      marginBottom: 3,
    },
    code: {
      fontFamily: 'monospace',
      fontSize: 'inherit',
      backgroundColor: 'muted',
      padding: 1,
      borderRadius: 'default',
    },
    table: {
      width: '100%',
      borderCollapse: 'separate',
      borderSpacing: 0,
      marginBottom: 3,
    },
    th: {
      textAlign: 'left',
      borderBottomStyle: 'solid',
      borderBottomWidth: '2px',
      borderBottomColor: 'primary',
      padding: 2,
      backgroundColor: 'muted',
    },
    td: {
      textAlign: 'left',
      borderBottomStyle: 'solid',
      borderBottomWidth: '1px',
      borderBottomColor: 'muted',
      padding: 2,
    },
    img: {
      maxWidth: '100%',
    },
    ul: {
      marginBottom: 3,
    },
    ol: {
      marginBottom: 3,
    },
    li: {
      marginBottom: 2,
    },
    blockquote: {
      color: 'gray',
      marginLeft: 0,
      marginRight: 0,
      paddingLeft: 3,
      borderLeftColor: 'primary',
      borderLeftStyle: 'solid',
      borderLeftWidth: '4px',
      fontStyle: 'italic',
      marginBottom: 3,
    },
  },
}

export default theme