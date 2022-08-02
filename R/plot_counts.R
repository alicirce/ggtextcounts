#' Lollipop plot
#'
#' Lollipop plots are (visually) lighter-weight versions of bar plots. This
#' ggpacket is composed of geom_point and geom_segment.
#' @name geom_lollipop
NULL

#' @describeIn geom_lollipop Lollipop plot with horizontal lines
#' @export
geom_h_lollipop <- ggpackets::ggpacket() +
  geom_point() +
  geom_segment(aes(xend = 0, yend = ..y..))

#' @describeIn geom_lollipop Lollipop plot with vertical lines
#' @export
geom_v_lollipop <- ggpackets::ggpacket() +
  geom_point() +
  geom_segment(aes(xend = ..x.., yend = 0))
