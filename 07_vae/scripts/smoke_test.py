"""Quick check that the VAE tutorial's Python deps work."""
import sys, importlib
deps = ["torch","numpy","pandas","sklearn","matplotlib","scipy","umap"]
for p in deps:
    try:
        m = importlib.import_module(p)
        print(f"OK  {p:<12} {getattr(m, '__version__', '?')}")
    except Exception as e:
        print(f"ERR {p}: {e}")
