ffi.cdef [[
	typedef float vec_t;
	typedef vec_t vec2_t[2];
	typedef vec_t vec3_t[3];
	typedef vec_t vec4_t[4];
	typedef vec_t vec5_t[5];
		
	typedef unsigned char 		byte;
	typedef enum {qfalse, qtrue}	qboolean;

	typedef int		qhandle_t;
	typedef int		sfxHandle_t;
	typedef int		fileHandle_t;
	typedef int		clipHandle_t;

	void	SCR_Init (void);
	void	SCR_UpdateScreen (void);

	void	SCR_DebugGraph (float value);

	int	SCR_GetBigStringWidth( const char *str );	// returns in virtual 640x480 coordinates

	void	SCR_AdjustFrom640( float *x, float *y, float *w, float *h );
	void	SCR_FillRect( float x, float y, float width, float height, const float *color );
	void	SCR_DrawPic( float x, float y, float width, float height, qhandle_t hShader );
	void	SCR_DrawNamedPic( float x, float y, float width, float height, const char *picname );

	void	SCR_DrawBigString( int x, int y, const char *s, float alpha, qboolean noColorEscape );			// draws a string with embedded color control characters with fade
	void	SCR_DrawBigStringColor( int x, int y, const char *s, vec4_t color, qboolean noColorEscape );	// ignores embedded color control characters
	void	SCR_DrawSmallStringExt( int x, int y, const char *string, float *setColor, qboolean forceColor, qboolean noColorEscape );
	void	SCR_DrawSmallChar( int x, int y, int ch );
]]