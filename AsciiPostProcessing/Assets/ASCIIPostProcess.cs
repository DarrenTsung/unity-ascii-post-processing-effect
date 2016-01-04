using System;
using UnityEngine;

namespace UnityStandardAssets.ImageEffects {
	[ExecuteInEditMode]
	public class ASCIIPostProcess : PostEffectsBase {
		[SerializeField]
		protected Shader _shader;
		protected Material _mat;
		
		[Header("Ascii Shader Properties")]
		[SerializeField]
		protected Texture2D _asciiMapTexture;
		[SerializeField]
		protected int _asciiMapCharacterCount = 7;
		
		[SerializeField]
		protected float _tilesX = 160;
		[SerializeField]
		protected float _tilesY = 50;
		[SerializeField]
		protected float _darkness = 0.8f;
		
		protected void Update() {
			this.CheckResources();
		}
		
		public override bool CheckResources() {
			this.CheckSupport(false);
			_mat = this.CheckShaderAndCreateMaterial(_shader, _mat);
			
			if (isSupported) {
				_mat.SetTexture("_AsciiMapTex", _asciiMapTexture);
				_mat.SetInt("_AsciiMapCharacterCount", _asciiMapCharacterCount);
				
				_mat.SetFloat("_tilesX", _tilesX);
				_mat.SetFloat("_tilesY", _tilesY);
				
				_mat.SetInt("_tilesW", (int)(1 / _tilesX));
				_mat.SetInt("_tilesH", (int)(1 / _tilesY));
				
				_mat.SetFloat("_darkness", _darkness);
			}
			
			return isSupported;
		}
		
		private void OnRenderImage(RenderTexture source, RenderTexture destination) {
			Graphics.Blit(source, destination, _mat);
		}
	}
}