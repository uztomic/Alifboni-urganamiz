package uz.uztomic.alifbo

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.util.TypedValue
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

/**
 * Builds a small, simple card ("category tile"-like) NativeAdView entirely
 * in code, so no XML layout resource is needed. Registered under the
 * factory id "listTile" in MainActivity and referenced from Dart via
 * NativeAd(factoryId: "listTile", ...).
 */
class ListTileNativeAdFactory(private val context: Context) : NativeAdFactory {

    private fun dp(value: Int): Int =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value.toFloat(), context.resources.displayMetrics).toInt()

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = NativeAdView(context)

        val root = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(dp(16), dp(14), dp(16), dp(14))
            setBackgroundColor(Color.parseColor("#FFFFFF"))
        }

        val iconView = ImageView(context).apply {
            layoutParams = LinearLayout.LayoutParams(dp(48), dp(48))
            scaleType = ImageView.ScaleType.CENTER_CROP
        }
        val iconContainer = LinearLayout(context).apply {
            layoutParams = LinearLayout.LayoutParams(dp(48), dp(48)).apply { marginEnd = dp(12) }
            addView(iconView)
        }

        val textColumn = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f)
        }

        val adBadge = TextView(context).apply {
            text = "Reklama"
            textSize = 10f
            setTextColor(Color.parseColor("#FF7A59"))
            setTypeface(typeface, Typeface.BOLD)
        }
        val headlineView = TextView(context).apply {
            textSize = 15f
            setTypeface(typeface, Typeface.BOLD)
            setTextColor(Color.parseColor("#3A3A3A"))
            maxLines = 1
        }
        val bodyView = TextView(context).apply {
            textSize = 12f
            setTextColor(Color.parseColor("#7A7A7A"))
            maxLines = 2
        }
        textColumn.addView(adBadge)
        textColumn.addView(headlineView)
        textColumn.addView(bodyView)

        val ctaView = Button(context).apply {
            textSize = 12f
            setPadding(dp(12), 0, dp(12), 0)
            isAllCaps = false
        }

        root.addView(iconContainer)
        root.addView(textColumn)
        root.addView(ctaView)
        adView.addView(root)

        adView.headlineView = headlineView
        adView.bodyView = bodyView
        adView.callToActionView = ctaView
        adView.iconView = iconView

        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body ?: ""
        (adView.callToActionView as Button).text = nativeAd.callToAction ?: "Ko'rish"
        val icon = nativeAd.icon
        if (icon != null) {
            iconView.setImageDrawable(icon.drawable)
            iconContainer.visibility = android.view.View.VISIBLE
        } else {
            iconContainer.visibility = android.view.View.GONE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
